package service

import (
	"errors"
	"fmt"
	"geekai/core/types"
	"geekai/store/model"
	"sync"
	"time"

	"gorm.io/gorm"
)

var ErrRewardAlreadyGranted = errors.New("reward already granted")

type UserService struct {
	db   *gorm.DB
	lock sync.Mutex
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{db: db, lock: sync.Mutex{}}
}

// IncreasePower 增加用户积分
func (s *UserService) IncreasePower(userId uint, power int, log model.PowerLog) error {
	s.lock.Lock()
	defer s.lock.Unlock()

	return s.db.Transaction(func(tx *gorm.DB) error {
		return s.IncreasePowerTx(tx, userId, power, log)
	})
}

// IncreasePowerTx 将积分、奖励流水与调用方的业务操作一起提交。
func (s *UserService) IncreasePowerTx(tx *gorm.DB, userId uint, power int, log model.PowerLog) error {
	if err := tx.Model(&model.User{}).Where("id", userId).UpdateColumn("power", gorm.Expr("power + ?", power)).Error; err != nil {
		return err
	}
	var user model.User
	if err := tx.Where("id", userId).First(&user).Error; err != nil {
		return err
	}
	// The user row is already locked by the balance update, including across instances.
	if log.RewardKey != nil {
		var count int64
		if err := tx.Model(&model.PowerLog{}).Where("reward_key = ?", *log.RewardKey).Count(&count).Error; err != nil {
			return err
		}
		if count > 0 {
			return ErrRewardAlreadyGranted
		}
	}
	entry := model.PowerLog{
		UserId: user.Id, Username: user.Username, Type: log.Type, Amount: power,
		Balance: user.Power, Mark: types.PowerAdd, Model: log.Model, Remark: log.Remark,
		CreatedAt: time.Now(), RewardKey: log.RewardKey,
	}
	if err := prepareRewardQuota(tx, user, &entry); err != nil {
		return err
	}
	return tx.Create(&entry).Error
}

// DecreasePower 减少用户积分
func (s *UserService) DecreasePower(userId uint, power int, log model.PowerLog) error {
	s.lock.Lock()
	defer s.lock.Unlock()

	tx := s.db.Begin()
	var user model.User
	tx.Where("id", userId).First(&user)
	if user.Power < power {
		tx.Rollback()
		return fmt.Errorf("用户积分不足")
	}

	err := tx.Model(&model.User{}).Where("id", userId).UpdateColumn("power", gorm.Expr("power - ?", power)).Error
	if err != nil {
		tx.Rollback()
		return fmt.Errorf("扣减积分失败：%v", err)
	}

	tx.Where("id", userId).First(&user)
	err = tx.Create(&model.PowerLog{
		UserId:    user.Id,
		Username:  user.Username,
		Type:      log.Type,
		Amount:    power,
		Balance:   user.Power,
		Mark:      types.PowerSub,
		Model:     log.Model,
		Remark:    log.Remark,
		CreatedAt: time.Now(),
	}).Error
	if err != nil {
		tx.Rollback()
		return fmt.Errorf("记录积分日志失败：%v", err)
	}
	tx.Commit()
	return nil
}
