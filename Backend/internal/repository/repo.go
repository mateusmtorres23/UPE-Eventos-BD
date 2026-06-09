package repository

import (
	"context"
	"errors"
	"agora-backend/internal/models"
	
	"github.com/jackc/pgx/v5/pgxpool"
)

type InfraRepository struct {
	db *pgxpool.Pool
}

func NewInfraRepository(db *pgxpool.Pool) *InfraRepository {
	return &InfraRepository{db: db}
}

func (r *InfraRepository) CriarReserva(ctx context.Context, res *models.ReservaAvulsa) error {
	query := `
		INSERT INTO reservas_avulsas (usuario_id, espaco_id, data_inicio, data_fim, motivo)
		VALUES ($1, $2, $3, $4, $5) RETURNING id;
	`
	// O pgx executa a query. Se houver conflito de horário, a Trigger do Postgres
	// vai barrar e retornar um erro contendo o estado do SQL (ex: código 45000 ou similar)
	err := r.db.QueryRow(ctx, query, res.UsuarioID, res.EspacoID, res.DataInicio, res.DataFim, res.Motivo).Scan(&res.ID)
	if err != nil {
		// Aqui você pode tratar especificamente o erro da trigger para repassar ao handler
		return errors.New("conflito de horário ou espaço indisponível") 
	}
	return nil
}