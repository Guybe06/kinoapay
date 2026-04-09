package domain

import "context"

/*
UserRepository définit le contrat pour la persistance des données utilisateur.
Il suit les principes de la Règle 07 (Feature-First) en isolant le contrat au domaine.
*/
type UserRepository interface {
	Create(ctx context.Context, user *User) error
	GetByID(ctx context.Context, id string) (*User, error)
	GetByPhone(ctx context.Context, countryCode string, phone string) (*User, error)
	Update(ctx context.Context, user *User) error
}
