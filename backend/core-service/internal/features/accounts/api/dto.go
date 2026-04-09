package api

/*
SignupRequest structure les données reçues pour l'inscription d'un nouvel utilisateur.
Elle expose les champs nécessaires à la création initiale d'un profil KinoaPay.
*/
type SignupRequest struct {
	CountryCode string `json:"countryCode" validate:"required"`
	Phone       string `json:"phone" validate:"required"`
	PIN         string `json:"pin" validate:"required,min=4,max=6"`
	DisplayName string `json:"displayName"`
}

/*
SignupResponse contient les données de confirmation renvoyées après un succès d'inscription.
Elle informe le client si un OTP a été envoyé pour la vérification du numéro.
*/
type SignupResponse struct {
	ID      string `json:"id"`
	Status  string `json:"status"`
	OTPSent bool   `json:"otpSent"`
}

/*
SigninRequest structure les données reçues pour l'authentification.
*/
type SigninRequest struct {
	Phone string `json:"phone" validate:"required"`
	PIN   string `json:"pin" validate:"required"`
}

/*
AuthResponse encapsule le jeton de sécurité et le profil minimal de l'utilisateur.
Elle est retournée après une authentification réussie.
*/
type AuthResponse struct {
	AccessToken string `json:"accessToken"`
	User        struct {
		ID          string `json:"id"`
		Phone       string `json:"phone"`
		DisplayName string `json:"displayName"`
		KYCLevel    string `json:"kycLevel"`
		Status      string `json:"status"`
	} `json:"user"`
}
