CREATE VIEW catalog_statistics_centers AS
SELECT 
    UPPER(center_name) as center_name,
    -- Promedio de edad
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS average_age,
    -- Promedio de altura
    ROUND(AVG(p.height_cm::numeric), 1) AS average_height,
    -- Total de hombres
    COUNT(CASE WHEN p.gender = 'mujer' THEN 1 END) AS total_men,
    -- Total de mujeres
    COUNT(CASE WHEN p.gender = 'hombre' THEN 1 END) AS total_women,
    -- Total de usuarios
    COUNT(*) AS total_users,
    -- Total de mayores de 60
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)) >= 60 THEN 1 END) AS total_over_60,
    -- Porcentaje de datos válidos
    ROUND((COUNT(p.date_of_birth) * 100.0) / NULLIF(COUNT(*), 0), 1) AS valid_data_percentage,
    -- Desviación estándar para la edad
    ROUND(STDDEV(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS stddev_age,
    -- Desviación estándar para la altura
    ROUND(STDDEV(p.height_cm::numeric), 1) AS stddev_height
FROM 
    public.dim_people p
JOIN 
    public.dim_centers dc ON p.center_identifier = dc.center_identifier
GROUP BY 
    dc.center_name
ORDER BY 
    average_age DESC NULLS LAST;



select * from catalog_statistics_centers csc limit 6

select * from centers c 
