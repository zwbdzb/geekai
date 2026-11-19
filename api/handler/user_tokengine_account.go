package handler

import (
	"context"
	"encoding/json"
	"errors"
	"geekai/service"
	"geekai/store/model"
	"strconv"
	"time"
)

func (h *UserHandler) ensureTokengineAccount(ctx context.Context, user model.User) {
	if !h.App.Config.TokengineOAuth.Enabled || h.App.Config.TokengineManagementToken() == "" ||
		user.TokengineID != nil && *user.TokengineID != "" || !registrationMobilePattern.MatchString(user.Mobile) {
		return
	}
	ctx, cancel := context.WithTimeout(ctx, 8*time.Second)
	defer cancel()
	err := func() error {
		var duplicates int64
		if err := h.DB.WithContext(ctx).Model(&model.User{}).Where("mobile = ? AND id <> ?", user.Mobile, user.Id).Count(&duplicates).Error; err != nil {
			return err
		}
		if duplicates > 0 {
			return &service.TokengineOAuthError{Reason: "local_mobile_conflict"}
		}
		profile, err := h.tokengineOAuth.EnsureAccount(ctx, user.Mobile, user.Nickname, h.App.Config.TokengineManagementToken())
		if err != nil {
			return err
		}
		identity := service.TokengineIdentity{Subject: "u_" + strconv.FormatInt(profile.ID, 10), Username: profile.Username, Phone: profile.Telephone}
		data, err := json.Marshal(tokengineSavedProfile{TokengineIdentity: identity, Profile: profile})
		if err != nil {
			return err
		}
		key := h.tokengineOAuth.IdentityKey(identity.Subject)
		// A concurrent OAuth login or mobile change must keep its established binding.
		return h.DB.WithContext(ctx).Model(&model.User{}).
			Where("id = ? AND mobile = ? AND (tokengine_id IS NULL OR tokengine_id = '')", user.Id, user.Mobile).
			Updates(map[string]any{"tokengine_id": key, "tokengine_subject": identity.Subject, "tokengine_profile": string(data)}).Error
	}()
	if err != nil {
		reason := "account_binding_failed"
		var failure *service.TokengineOAuthError
		if errors.As(err, &failure) {
			reason = failure.Reason
		}
		logger.Warnw("tokengine_account_provision_failed", "user_id", user.Id, "reason", reason)
	}
}
