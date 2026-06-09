package handlers

import (
	"encoding/json"
	"net/http"
	"agora-backend/internal/models"
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

	var req models.ReservaAvulsa
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "JSON inválido", http.StatusBadRequest)
		return
	}

	// Executa a lógica chamando o repositório (com o contexto da requisição)
	err := h.repo.CriarReserva(r.Context(), &req)
	if err != nil {
		// Atendendo à especificação: Devolve 409 se a trigger bloquear por conflito
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusConflict)
		json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(req)
}