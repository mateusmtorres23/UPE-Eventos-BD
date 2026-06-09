CREATE FUNCTION fn_check_space_availability()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM space_reservations 
        WHERE id_space = NEW.id_space
        -- A mágica da intersecção de datas:
        AND (NEW.date_start < date_end AND NEW.date_end > date_start)
    ) THEN
        RAISE EXCEPTION 'Conflito de agendamento! O espaço já está reservado neste horário.';
    END IF;
    
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_prevent_space_double_booking
BEFORE INSERT OR UPDATE ON space_reservations
FOR EACH ROW
EXECUTE FUNCTION fn_check_space_availability();

CREATE PROCEDURE prc_generate_batch_certificates(p_event_id UUID, p_default_hours INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insere um certificado para cada aluno que está na tabela registrations_event
    INSERT INTO certificates (id, total_hours, issue_date, id_event, id_student)
    SELECT 
        gen_random_uuid(), 
        p_default_hours, 
        CURRENT_DATE, 
        p_event_id, 
        re.id_participant
    FROM registrations_event re
    JOIN students s ON re.id_participant = s.id_user
    WHERE re.id_event = p_event_id
    -- Garante que não vai gerar duplicado se a procedure for rodada duas vezes
    AND NOT EXISTS (
        SELECT 1 FROM certificates c 
        WHERE c.id_event = p_event_id AND c.id_student = re.id_participant
    );

    RAISE NOTICE 'Certificados gerados em lote com sucesso para o evento.';
END;
$$;