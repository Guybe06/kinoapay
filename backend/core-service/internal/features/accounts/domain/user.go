package domain

import "time"

/*
User représente l'entité centrale d'un utilisateur dans le système KinoaPay.
Il porte les informations d'identité, de contact et de conformité KYC.
Conformément à la Règle 99, aucun commentaire n'est présent dans le corps des fonctions.
*/
type User struct {
	ID          string    `json:"id"`
	Phone       string    `json:"phone"`
	CountryCode string    `json:"country_code"`
	DisplayName string    `json:"display_name"`
	PINHash     string    `json:"-"`
	KYCLevel    string    `json:"kyc_level"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

// UserStatus définit les différents états possibles d'un compte utilisateur.
const (
	StatusPending  = "PENDING"
	StatusActive   = "ACTIVE"
	StatusSuspended = "SUSPENDED"
)

// KYCLevel définit les paliers de vérification d'identité.
const (
	KYCLevel0 = "L0" // Non vérifié (limites basses)
	KYCLevel1 = "L1" // Identité vérifiée
	KYCLevel2 = "L2" // Résidence vérifiée
)
