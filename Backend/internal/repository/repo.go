package repository

import (	
	"github.com/jackc/pgx/v5/pgxpool"
)

type InfraRepository struct {
	db *pgxpool.Pool
}

func NewInfraRepository(db *pgxpool.Pool) *InfraRepository {
	return &InfraRepository{db: db}
}