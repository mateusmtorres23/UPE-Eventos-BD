## Documentação - PT/BR

### Módulo: Views, Triggers e Procedures
Este documento descreve os componentes de banco de dados criados para otimizar consultas, garantir regras de negócio e facilitar a integração com a API.

#### 1. Views

vw_complete_users

    Motivo: Abstrair a complexidade do modelo de herança de usuários (Tabela Pai/Filha). Esta view centraliza os dados, permitindo que a API busque as informações completas de um usuário (incluindo dados específicos de alunos, cursos ou professores) com um único SELECT, sem precisar reescrever múltiplos LEFT JOINs no backend.

vw_user_event_registrations

    Motivo: Fornecer um relatório consolidado e rápido de quem está inscrito em cada evento. Facilita a geração de listas de presença e auditoria de inscritos, cruzando dados de usuários e eventos de forma otimizada.

vw_user_activity_registrations

    Motivo: Criar uma extração focada no nível mais granular do sistema (as atividades). A view já traz embutido a qual evento a atividade pertence, evitando que o backend precise fazer requisições extras para montar o cronograma individual de cada participante.

#### 2. Procedures e Triggers

trg_prevent_schedule_conflict (via fn_check_participant_schedule)

    Motivo: Garantir a integridade da agenda dos usuários na camada mais profunda do sistema. O trigger impede proativamente a "clonagem" de participantes, bloqueando a inserção no banco caso um usuário tente se inscrever em duas atividades que aconteçam no mesmo intervalo de tempo.


prc_generate_batch_certificates (Procedure)

    Motivo: Resolver um problema de gargalo de rede e performance. Em vez da aplicação fazer centenas de inserções individuais (INSERT) para gerar os certificados ao final de um evento, essa rotina realiza um Bulk Insert nativo e em lote diretamente no motor do banco de dados, gerando todos os certificados de uma só vez de forma segura.

fn_get_event_analytics_json (Function)

    Motivo: Aproveitar o processamento nativo de JSON do PostgreSQL para consolidar métricas de um evento (contagem de atividades, quebra de participantes por tipo). A função entrega um objeto JSON pronto para a API, eliminando a necessidade de agregações complexas e loops na camada de aplicação.

## Documentation - EN

### Module: Views, Triggers, and Procedures
This document outlines the database components created to optimize queries, enforce business rules, and streamline API integration.
#### 1. Views

vw_complete_users

    Purpose: To abstract the complexity of the user inheritance model (Parent/Child tables). This view centralizes the data, allowing the API to fetch a complete user profile (including specific student, course, or professor data) with a single SELECT, bypassing the need to write multiple LEFT JOINs in the backend code.

vw_user_event_registrations

    Purpose: To provide a fast, consolidated report of event enrollments. It facilitates the generation of attendance lists and enrollment auditing by optimally joining user and event data.

vw_user_activity_registrations

    Purpose: To create an extraction focused on the most granular level of the system (activities). The view automatically includes the parent event of the activity, saving the backend from making additional requests when building an individual participant's schedule.

#### 2. Procedures and Triggers

trg_prevent_schedule_conflict (via fn_check_participant_schedule)

    Purpose: To enforce user schedule integrity at the deepest layer of the system. The trigger proactively prevents participant "cloning" by blocking database inserts if a user attempts to register for two activities that overlap in time.

prc_generate_batch_certificates (Procedure)

    Purpose: To solve network and performance bottleneck issues. Instead of the application making hundreds of individual INSERT requests to generate certificates at the end of an event, this routine performs a native Bulk Insert directly within the database engine, safely generating all certificates at once.

fn_get_event_analytics_json (Function)

    Purpose: To leverage PostgreSQL's native JSON processing capabilities to consolidate event metrics (activity count, participant breakdown by type). The function delivers a ready-to-use JSON object to the API, eliminating the need for complex aggregations and data mapping loops in the application layer.