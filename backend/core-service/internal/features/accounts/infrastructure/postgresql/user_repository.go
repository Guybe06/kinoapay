package postgresql

import (
	"context"
	"database/sql"
	"fmt"

	"github.com/kinoapay/core-service/internal/features/accounts/domain"
)

/*
UserRepositoryImpl implémente le contrat domain.UserRepository pour PostgreSQL.
Il respecte la Règle 99 en n'ayant aucun commentaire à l'intérieur des méthodes.
*/
type UserRepositoryImpl struct {
	db *sql.DB
}

/*
NewUserRepository crée une nouvelle instance de UserRepositoryImpl.
*/
func NewUserRepository(db *sql.DB) domain.UserRepository {
	return &UserRepositoryImpl{db: db}
}

/*
Create insère un nouvel utilisateur dans la base de données.
*/
func (r *UserRepositoryImpl) Create(ctx context.Context, user *domain.User) error {
	query := `INSERT INTO users (id, first_name, last_name, country_code, phone_number, pin_hash, status, created_at, updated_at)
              VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	_, err := r.db.ExecContext(ctx, query,
		user.ID,
		user.FirstName,
		user.LastName,
		user.CountryCode,
		user.PhoneNumber,
		user.PINHash,
		user.Status,
		user.CreatedAt,
		user.UpdatedAt,
	)

	if err != nil {
		return fmt.Errorf("failed to insert user: %w", err)
	}

	return nil
}

/*
GetByID récupère un utilisateur par son identifiant unique.
*/
func (r *UserRepositoryImpl) GetByID(ctx context.Context, id string) (*domain.User, error) {
	query := `SELECT id, first_name, last_name, country_code, phone_number, pin_hash, status, created_at, updated_at
              FROM users WHERE id = $1`

	user := &domain.User{}
	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&user.ID,
		&user.FirstName,
		&user.LastName,
		&user.CountryCode,
		&user.PhoneNumber,
		&user.PINHash,
		&user.Status,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}

	if err != nil {
		return nil, fmt.Errorf("failed to get user by id: %w", err)
	}

	return user, nil
}

/*
GetByPhone récupère un utilisateur par son numéro de téléphone.
*/
func (r *UserRepositoryImpl) GetByPhone(ctx context.Context, countryCode string, phone string) (*domain.User, error) {
	query := `SELECT id, first_name, last_name, country_code, phone_number, pin_hash, status, created_at, updated_at
              FROM users WHERE country_code = $1 AND phone_number = $2`

	user := &domain.User{}
	err := r.db.QueryRowContext(ctx, query, countryCode, phone).Scan(
		&user.ID,
		&user.FirstName,
		&user.LastName,
		&user.CountryCode,
		&user.PhoneNumber,
		&user.PINHash,
		&user.Status,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}

	if err != nil {
		return nil, fmt.Errorf("failed to get user by phone: %w", err)
	}

	return user, nil
}

/*
Update met à jour les informations d'un utilisateur existant.
*/
func (r *UserRepositoryImpl) Update(ctx context.Context, user *domain.User) error {
	query := `UPDATE users SET first_name = $1, last_name = $2, status = $3, updated_at = $4 WHERE id = $5`

	_, err := r.db.ExecContext(ctx, query,
		user.FirstName,
		user.LastName,
		user.Status,
		user.UpdatedAt,
		user.ID,
	)

	if err != nil {
		return fmt.Errorf("failed to update user: %w", err)
	}

	return nil
}
