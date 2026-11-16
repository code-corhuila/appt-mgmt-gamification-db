INSERT INTO achievements (id, title, description, icon_key, target)
VALUES
    ('first_pill', 'Primer Paso', 'Toma tu primer medicamento registrado', 'medication', 1),
    ('med_streak_3', 'Constancia Inicial', 'Toma 3 dosis de medicamentos', 'streak', 3),
    ('med_streak_10', 'Paciente Ejemplar', 'Toma 10 dosis de medicamentos', 'award', 10),
    ('record_health', 'Auto-Control', 'Registra tus signos vitales por primera vez', 'health-record', 1),
    ('first_appointment', 'Responsable', 'Agenda tu primera cita médica', 'appointment', 1)
ON CONFLICT (id) DO NOTHING;
