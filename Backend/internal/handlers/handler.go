package handlers

import (
	"net/http"
	"agora-backend/internal/repository"
)

type InfraHandler struct {
	repo *repository.InfraRepository
}

func NewInfraHandler(repo *repository.InfraRepository) *InfraHandler {
	return &InfraHandler{repo: repo}
}

func (h *InfraHandler) ReservarEspacoHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Método não permitido", http.StatusMethodNotAllowed)
		return
	}
}