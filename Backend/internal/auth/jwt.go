package auth

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type CustomClaims struct {
	UserID string `json:"user_id"`
	Role   string `json:"role"`
	jwt.RegisteredClaims
}

func getJWTSecret() ([]byte, error) {
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		return nil, errors.New("a variável de ambiente JWT_SECRET não foi configurada")
	}
	return []byte(secret), nil
}

func GenerateToken(userID pgtype.UUID, userType string) (string, error) {
	secretKey, err := getJWTSecret()
	if err != nil {
		return "", err
	}

	parsedUUID, err := uuid.FromBytes(userID.Bytes[:])
	if err != nil {
		return "", errors.New("erro interno ao processar o identificador de segurança do usuário")
	}

	claims := CustomClaims{
	UserID: parsedUUID.String(),
	Role:   userType,
	RegisteredClaims: jwt.RegisteredClaims{
		Subject:   parsedUUID.String(),
		Issuer:    "agora-api",
		IssuedAt:  jwt.NewNumericDate(time.Now()),
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(8 * time.Hour)),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	tokenString, err := token.SignedString(secretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}