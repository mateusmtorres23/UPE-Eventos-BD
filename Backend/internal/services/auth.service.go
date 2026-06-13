package services

import (
	"context"
	"errors"
	"log"

	"agora-backend/internal/auth"
	"agora-backend/internal/dto"
	"agora-backend/internal/repository"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	repo *repository.Queries
}

func NewAuthService(repo *repository.Queries) *AuthService {
	return &AuthService{repo: repo}
}

func (s *AuthService) Authenticate(ctx context.Context, req dto.LoginRequest) (string, error) {
	user, err := s.repo.GetUserByEmail(ctx, req.Email)
	if err != nil {
		log.Println("falha de autenticação")
		return "", errors.New("credenciais inválidas")
	}

	if err := bcrypt.CompareHashAndPassword(
		[]byte(user.PasswordHash),
		[]byte(req.Password),
	); err != nil {
		log.Println("falha de autenticação")
		return "", errors.New("credenciais inválidas")
	}

	token, err := auth.GenerateToken(user.ID, string(user.UserType))
	if err != nil {
		log.Printf("erro ao gerar token JWT: %v", err)
		return "", errors.New("erro interno ao gerar credencial de acesso")
	}

	return token, nil
}