CREATE VIEW catalog_statistics_centers_people AS
SELECT 
    dc.center_identifier,
    UPPER(dc.center_name) as center_name,
    UPPER(dc.manager_legal_personality) as manager_legal_personality,
    UPPER(p.occupied_place_type ) as occupied_place_type,
    --Numero de plazas concertadas
    dc.num_contracted_places,
    -- Total de usuarios
    COUNT(*) AS total_users,
    -- Promedio de edad
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS average_age,
    -- Promedio de altura
    ROUND(AVG(p.height_cm::numeric), 1) AS average_height,
    -- Promedio de peso
    ROUND(AVG(p.last_weight::numeric), 1) AS average_weight,
    -- Cálculo del IMC (evitar división por cero)
    ROUND(
        AVG(CASE WHEN p.height_cm > 0 THEN p.last_weight::numeric / (POW(p.height_cm / 100, 2)) ELSE NULL END)::numeric, 
        1
    ) AS average_imc,  
    -- Desviación estándar para la edad
    ROUND(STDDEV(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS stddev_age,
    -- Desviación estándar para la altura
    ROUND(STDDEV(p.height_cm::numeric), 1) AS stddev_height,
    -- Desviación estándar para el IMC (agregado correctamente)
    ROUND(STDDEV(
        CASE WHEN p.height_cm > 0 THEN p.last_weight::numeric / (POW(p.height_cm / 100, 2)) ELSE NULL END
    )::numeric, 1) AS stddev_imc,
    -- Porcentaje de datos válidos en toda la data (considerando todas las columnas relevantes)
    ROUND((
    (COUNT(*) 
    - COUNT(CASE WHEN p.date_of_birth IS NULL THEN 1 END)
    - COUNT(CASE WHEN p.height_cm IS NULL THEN 1 END)
    - COUNT(CASE WHEN p.last_weight IS NULL THEN 1 END)
    - COUNT(CASE WHEN p.gender IS NULL THEN 1 END)
    - COUNT(CASE WHEN p.center_identifier IS NULL THEN 1 END)
    -- Agrega más columnas que quieras verificar como nulas
    ) * 100.0) / NULLIF(COUNT(*), 0), 1) AS valid_data_percentage
FROM 
    public.dim_people p
JOIN 
    public.dim_centers dc ON p.center_identifier = dc.center_identifier
GROUP BY 
    dc.center_identifier, 
    dc.center_name,
    dc.manager_legal_personality,
    p.occupied_place_type,
    dc.num_contracted_places
ORDER BY 
    average_age DESC NULLS LAST;


SELECT
    p.manager_legal_personality AS category,
    SUM(p.total_users) AS total_users,
    ROUND(AVG(p.average_age)::numeric, 2) AS avg_age,
    ROUND(AVG(p.average_height)::numeric, 2) AS avg_height,
    ROUND(AVG(p.average_weight)::numeric, 2) AS avg_weight
FROM
    catalog_statistics_centers_people p
GROUP BY
    p.manager_legal_personality