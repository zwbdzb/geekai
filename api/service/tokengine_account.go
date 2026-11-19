package service

import (
	"context"
	"encoding/json"
	"net/http"
	"net/url"
	"regexp"
	"strconv"
	"strings"
)

var tokengineAccountMobile = regexp.MustCompile(`^1[3-9]\d{9}$`)

// EnsureAccount is idempotent by verified phone; it never shares the local password.
func (s *TokengineOAuth) EnsureAccount(ctx context.Context, mobile, nickname, serviceToken string) (*TokengineUserProfile, error) {
	base, err := oauthConfigURL(s.config.BaseURL)
	serviceToken = strings.TrimSpace(serviceToken)
	if !s.config.Enabled || err != nil || base.Path != "" || serviceToken == "" || strings.ContainsAny(serviceToken, "\r\n") {
		return nil, &TokengineOAuthError{Reason: "account_not_configured"}
	}
	if !tokengineAccountMobile.MatchString(mobile) {
		return nil, &TokengineOAuthError{Reason: "invalid_account_mobile"}
	}
	profile, err := s.accountByMobile(ctx, mobile, serviceToken)
	if err != nil || profile != nil {
		return profile, err
	}
	password, err := OAuthRandom()
	if err != nil {
		return nil, &TokengineOAuthError{Reason: "account_password_failed", cause: err}
	}
	displayName := []rune(strings.TrimSpace(nickname))
	if len(displayName) > 20 {
		displayName = displayName[:20]
	}
	body, _ := json.Marshal(map[string]any{
		"username": "gk_" + s.IdentityKey("mobile:" + mobile)[:17],
		"password": password[:20], "display_name": string(displayName), "telephone": mobile,
		"role": 1,
	})
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, s.config.BaseURL+"/api/user/", strings.NewReader(string(body)))
	if err != nil {
		return nil, &TokengineOAuthError{Reason: "invalid_account_request", cause: err}
	}
	req.Header.Set("Authorization", "Bearer "+serviceToken)
	req.Header.Set("Content-Type", "application/json")
	var result struct {
		Success bool `json:"success"`
	}
	createErr := s.readJSON(req, &result)
	// Search again also recovers concurrent creation and a lost create response.
	profile, err = s.accountByMobile(ctx, mobile, serviceToken)
	if err != nil || profile != nil {
		return profile, err
	}
	if createErr != nil {
		return nil, createErr
	}
	if !result.Success {
		return nil, &TokengineOAuthError{Reason: "account_create_rejected"}
	}
	return nil, &TokengineOAuthError{Reason: "account_not_found_after_create"}
}

func (s *TokengineOAuth) accountByMobile(ctx context.Context, mobile, serviceToken string) (*TokengineUserProfile, error) {
	const pageSize = 100
	for page := 1; ; page++ {
		query := url.Values{"keyword": {mobile}, "p": {strconv.Itoa(page)}, "page_size": {strconv.Itoa(pageSize)}}
		req, err := http.NewRequestWithContext(ctx, http.MethodGet, s.config.BaseURL+"/api/user/search?"+query.Encode(), nil)
		if err != nil {
			return nil, &TokengineOAuthError{Reason: "invalid_account_search_request", cause: err}
		}
		req.Header.Set("Authorization", "Bearer "+serviceToken)
		var result struct {
			Success bool `json:"success"`
			Data    *struct {
				Total *int64 `json:"total"`
				Items []struct {
					ID        int64  `json:"id"`
					Telephone string `json:"telephone"`
				} `json:"items"`
			} `json:"data"`
		}
		if err := s.readJSON(req, &result); err != nil {
			return nil, err
		}
		if !result.Success || result.Data == nil || result.Data.Total == nil || *result.Data.Total < 0 {
			return nil, &TokengineOAuthError{Reason: "invalid_account_search_response"}
		}
		if len(result.Data.Items) == 0 && *result.Data.Total > int64((page-1)*pageSize) {
			return nil, &TokengineOAuthError{Reason: "invalid_account_search_response"}
		}
		// Search is fuzzy; only a full phone match can establish a binding.
		for _, user := range result.Data.Items {
			if user.Telephone != mobile {
				continue
			}
			profile, err := s.UserProfile(ctx, "u_"+strconv.FormatInt(user.ID, 10), serviceToken)
			if err != nil {
				return nil, err
			}
			if profile.Telephone != mobile {
				return nil, &TokengineOAuthError{Reason: "account_mobile_mismatch"}
			}
			return profile, nil
		}
		if int64(page*pageSize) >= *result.Data.Total {
			return nil, nil
		}
		if len(result.Data.Items) < pageSize {
			return nil, &TokengineOAuthError{Reason: "invalid_account_search_response"}
		}
	}
}
