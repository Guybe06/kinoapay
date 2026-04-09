package application

import (
	"context"
	"fmt"
	"time"

	"github.com/kinoapay/core-service/internal/features/accounts/domain"
)

/*
AuthService orchestre les opérations d'authentification et de gestion de compte.
Cette couche application applique la Règle 99: pas de commentaire dans le corps des fonctions.
*/
type AuthService struct {
	repo domain.UserRepository
}

// NewAuthService initialise un nouveau service d'authentification.
func NewAuthService(repo domain.UserRepository) *AuthService {
	return &AuthService{repo: repo}
}

// Signup gère la création d'un compte utilisateur en attente de vérification OTP.
func (s *AuthService) Signup(ctx context.Context, countryCode, phone, pin, displayName string) (*domain.User, error) {
	existing, _ := s.repo.GetByPhone(ctx, countryCode, phone)
	if existing != nil {
		return nil, fmt.Errorf("phone number already registered")
	}

	user := &domain.User{
		ID:          "FIXME-UUID", // TODO: Implement UUID generator
		Phone:       phone,
		CountryCode: countryCode,
		DisplayName: displayName,
		PINHash:     pin, // FIXME: Implement secure hashing
		KYCLevel:    domain.KYCLevel0,
		Status:      domain.StatusPending,
		CreatedAt:   time.Now(),
		UpdatedAt:   time.Now(),
	}

	if err := s.repo.Create(ctx, user); err != nil {
		return nil, err
	}

	return user, nil
}
