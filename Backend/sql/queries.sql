-- name: CreateSpaceReservation :one
INSERT INTO space_reservations (
    id, id_space, id_user, date_start, date_end
) VALUES (
    $1, $2, $3, $4, $5
) RETURNING *;