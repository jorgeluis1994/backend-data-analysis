CREATE OR REPLACE FUNCTION get_center_user_stats(
    p_center_identifier TEXT, 
    p_column_name TEXT
)
RETURNS TABLE(
    center_identifier character varying(255),
    center_name text,
    value NUMERIC
) 
LANGUAGE plpgsql
AS $$
BEGIN
    -- Generamos la consulta dinámica en base a la columna seleccionada
    RETURN QUERY EXECUTE format(
        'SELECT 
            center_identifier,
            center_name,
            %I
        FROM 
            center_user_stats
        WHERE 
            center_identifier = $1', 
        p_column_name
    ) USING p_center_identifier;
END;
$$;


SELECT 
    dc.center_identifier,
    UPPER(dc.center_name) AS center_name,
    -- Promedio de edad
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS average_age,
    -- Promedio de altura
    ROUND(AVG(p.height_cm::numeric), 1) AS average_height,
    -- Promedio de IMC (usando peso y altura)
    ROUND(AVG((p.last_weight / (p.height_cm * p.height_cm))::numeric), 1) AS average_imc,
    -- Desviación estándar para edad
    ROUND(STDDEV(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.date_of_birth)))::numeric, 1) AS stddev_age,
    -- Desviación estándar para altura
    ROUND(STDDEV(p.height_cm::numeric), 1) AS stddev_height,
    -- Desviación estándar para IMC
    ROUND(STDDEV((p.last_weight / (p.height_cm * p.height_cm))::numeric), 1) AS stddev_imc,
    -- Total de usuarios
    COUNT(*) AS total_users
FROM 
    public.dim_people p
INNER JOIN 
    public.dim_centers dc ON p.center_identifier = dc.center_identifier
GROUP BY 
    dc.center_identifier,
    dc.center_name;