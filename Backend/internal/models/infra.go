// reserva de espaços
package models

import "time"

type ReservaAvulsa struct {
	ID         int       `json:"id"`
	UsuarioID  int       `json:"usuario_id"`
	EspacoID   int       `json:"espaco_id"`
	DataInicio time.Time `json:"data_inicio"`
	DataFim    time.Time `json:"data_fim"`
	Motivo     string    `json:"motivo"`
}