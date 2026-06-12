CREATE OR REPLACE VIEW vw_complete_users AS
SELECT 
    u.id, 
    u.name AS user_name, 
    u.institutional_email, 
    u.user_type, 
    s.enrollment_number, 
    c.name AS course_name,
    p.credential_number
FROM users u
LEFT JOIN students s ON u.id = s.id_user
LEFT JOIN courses c ON s.id_course = c.id
LEFT JOIN professors p ON u.id = p.id_user
LEFT JOIN employees e ON u.id = e.id_user;

CREATE VIEW vw_user_event_registrations AS
SELECT 
    re.id AS registration_id,
    re.registration_date,
    u.id AS user_id,
    u.name AS user_name,
    u.institutional_email,
    e.id AS event_id,
    e.name AS event_name,
    e.date_start,
    e.date_end,
    e.name_organizer
FROM registrations_event re
JOIN users u ON re.id_participant = u.id
JOIN events e ON re.id_event = e.id;

CREATE OR REPLACE VIEW vw_user_activity_registrations AS
SELECT 
    ra.id AS registration_id,
    ra.registration_date,
    u.id AS user_id,
    u.name AS user_name,
    u.institutional_email,
    a.id AS activity_id,
    a.name AS activity_name,
    a.category,
    a.date_start,
    a.date_end,
    e.name AS event_name  
FROM registrations_activity ra
JOIN users u ON ra.id_participant = u.id
JOIN activities a ON ra.id_activity = a.id
JOIN events e ON a.id_event = e.id;

