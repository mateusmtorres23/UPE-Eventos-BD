CREATE TYPE type_user AS ENUM ('student', 'professor', 'employee');

CREATE TABLE users (
    id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    institutional_email VARCHAR(50) UNIQUE NOT NULL,
    user_type type_user NOT NULL
);

CREATE TABLE courses (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE students (
    id_user UUID PRIMARY KEY REFERENCES users(id) NOT NULL,
    enrollment_number VARCHAR(100) UNIQUE NOT NULL,
    id_course UUID REFERENCES courses(id) NOT NULL
);

CREATE TABLE professors (
    id_user UUID PRIMARY KEY REFERENCES users(id) NOT NULL, 
    credential_number VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE employees (
    id_user UUID PRIMARY KEY REFERENCES users(id) NOT NULL
);

CREATE TABLE events (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, 
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    description VARCHAR(600) NOT NULL,
    name_organizer VARCHAR(100) NOT NULL,
    CHECK (date_end > date_start)
);

CREATE TYPE categoria_atividade AS ENUM (
    'palestra',
    'minicurso',
    'mesa_redonda',
    'oficina',
    'workshop',
    'painel',
    'apresentacao_trabalho',
    'abertura_encerramento'
);

CREATE TABLE activities (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    category categoria_atividade NOT NULL,
    description VARCHAR(500) NOT NULL,
    id_event UUID REFERENCES events(id) NOT NULL,
    CHECK (date_end > date_start)
);

CREATE TABLE equipment (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TYPE status_space AS ENUM (
    'disponivel',
    'reservado',
    'manutencao',
    'inativo'
);

CREATE TYPE type_space AS ENUM (
    'sala_de_aula',
    'laboratorio',
    'auditorio',
    'area_externa'
);

CREATE TABLE spaces (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    type type_space NOT NULL,
    status status_space NOT NULL,
    block VARCHAR(50) NOT NULL
);

CREATE TABLE certificates (
    id UUID PRIMARY KEY,
    total_hours INT NOT NULL,
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    id_event UUID REFERENCES events(id) NOT NULL,
    id_student UUID REFERENCES students(id_user) NOT NULL
);

CREATE TABLE registrations_event (
    id UUID PRIMARY KEY,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_participant UUID REFERENCES users(id) NOT NULL,
    id_event UUID REFERENCES events(id) NOT NULL,
    CONSTRAINT uk_participant_event UNIQUE (id_participant, id_event)
);

CREATE TABLE registrations_activity (
    id UUID PRIMARY KEY,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_participant UUID REFERENCES users(id) NOT NULL,
    id_activity UUID REFERENCES activities(id) NOT NULL,
    CONSTRAINT uk_participant_activity UNIQUE (id_participant, id_activity)
);

CREATE TABLE professors_courses (
    id UUID PRIMARY KEY,
    id_professor UUID REFERENCES professors(id_user) NOT NULL,
    id_course UUID REFERENCES courses(id) NOT NULL,
    CONSTRAINT uk_professor_course UNIQUE (id_professor, id_course)
);

CREATE TABLE space_reservations (
    id UUID PRIMARY KEY,
    id_space UUID REFERENCES spaces(id) NOT NULL,
    id_user UUID REFERENCES users(id) NOT NULL,
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    CHECK (date_end > date_start)
);

CREATE TABLE equipment_reservations (
    id UUID PRIMARY KEY,
    id_equipment UUID REFERENCES equipment(id) NOT NULL,
    id_user UUID REFERENCES users(id) NOT NULL,
    date_start TIMESTAMP NOT NULL,
    date_end TIMESTAMP NOT NULL,
    CHECK (date_end > date_start)
);