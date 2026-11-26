package store

// * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// * Copyright 2023 The Geek-AI Authors. All rights reserved.
// * Use of this source code is governed by a Apache-2.0 license
// * that can be found in the LICENSE file.
// * @Author yangjian102621@163.com
// * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

import (
	"fmt"
	"geekai/core/types"
	"geekai/log"
	"time"

	mysqldriver "github.com/go-sql-driver/mysql"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	logger2 "gorm.io/gorm/logger"
)

var logger = log.GetLogger()

func NewGormConfig() *gorm.Config {
	return &gorm.Config{
		Logger: logger2.Default.LogMode(logger2.Warn),
	}
}

func NewMysql(config *gorm.Config, appConfig *types.AppConfig) (*gorm.DB, error) {
	dns, err := withDialTimeout(appConfig.MysqlDns)
	if err != nil {
		return nil, fmt.Errorf("invalid MySQL DSN: %v", err)
	}
	db, err := gorm.Open(mysql.Open(dns), config)
	if err != nil {
		return nil, fmt.Errorf("MySQL 连接失败: %v", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		return nil, err
	}

	sqlDB.SetMaxIdleConns(32)
	sqlDB.SetMaxOpenConns(512)
	sqlDB.SetConnMaxLifetime(time.Hour)

	logger.Info("开始重命名数据表...")

	// 重命名数据表
	tableRenames := map[string]string{
		"chatgpt_chat_roles":      "chat_roles",
		"chatgpt_admin_users":     "admin_users",
		"chatgpt_api_keys":        "api_keys",
		"chatgpt_app_types":       "app_types",
		"chatgpt_chat_history":    "chat_history",
		"chatgpt_chat_items":      "chat_items",
		"chatgpt_chat_models":     "chat_models",
		"chatgpt_users":           "users",
		"chatgpt_orders":          "orders",
		"chatgpt_products":        "products",
		"chatgpt_configs":         "configs",
		"chatgpt_mj_jobs":         "mj_jobs",
		"chatgpt_suno_jobs":       "suno_jobs",
		"chatgpt_dall_jobs":       "dall_jobs",
		"chatgpt_video_jobs":      "video_jobs",
		"chatgpt_jimeng_jobs":     "jimeng_jobs",
		"chatgpt_files":           "files",
		"chatgpt_menus":           "menus",
		"chatgpt_functions":       "functions",
		"chatgpt_invite_codes":    "invite_codes",
		"chatgpt_invite_logs":     "invite_logs",
		"chatgpt_redeems":         "redeems",
		"chatgpt_power_logs":      "power_logs",
		"chatgpt_user_login_logs": "user_login_logs",
	}

	// 执行重命名操作
	for oldTableName, newTableName := range tableRenames {
		if db.Migrator().HasTable(oldTableName) && !db.Migrator().HasTable(newTableName) {
			err := db.Exec(fmt.Sprintf("ALTER TABLE %s RENAME TO %s", oldTableName, newTableName)).Error
			if err != nil {
				logger.Errorf("重命名数据表 %s 到 %s 失败: %v", oldTableName, newTableName, err)
			} else {
				logger.Infof("成功重命名数据表: %s -> %s", oldTableName, newTableName)
			}
		}
	}
	return db, nil
}

// withDialTimeout 为 DSN 填充连接和读写超时，避免数据库不可达时长时间卡住。
// DSN 中已显式指定（如 timeout=5s）的参数优先，仅在未指定时填充默认值。
func withDialTimeout(dsn string) (string, error) {
	cfg, err := mysqldriver.ParseDSN(dsn)
	if err != nil {
		return "", err
	}
	if cfg.Timeout == 0 {
		cfg.Timeout = 5 * time.Second
	}
	if cfg.ReadTimeout == 0 {
		cfg.ReadTimeout = 30 * time.Second
	}
	if cfg.WriteTimeout == 0 {
		cfg.WriteTimeout = 30 * time.Second
	}
	return cfg.FormatDSN(), nil
}
