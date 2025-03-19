CREATE OR REPLACE VIEW center_user_stats_type AS
SELECT 
    dc.center_identifier,
    UPPER(dc.center_name) AS center_name,
    UPPER(
    CASE 
		        WHEN (dc.restriction_free_center = 'false') 
		            THEN 'Residencia con resticcion'
		        WHEN dc.restriction_free_center = 'true' 
		            THEN 'Residencia sin resticcion'
		        ELSE 'Resto de residencias'
		    END
		) AS type_restric,
    UPPER(
    CASE 
		        WHEN (dc.has_psychogeriatric_places = 'true' OR dc.has_paliative_places = 'true') 
		            THEN 'Residencia Psicogeriátrico/Paliativo'
		        WHEN dc.has_autonomous_places = 'true' 
		            THEN 'Residencia Autónoma'
		        ELSE 'Resto de residencias'
		    END
		) AS type_center,
	UPPER(
    CASE 
        WHEN dc.holder_legal_personality = 'privada_mercantil' AND (dc.has_psychogeriatric_places = 'true' OR dc.has_paliative_places = 'true') 
            THEN 'Residencia privada'
        WHEN dc.holder_legal_personality = 'publica' 
            THEN 'Residencia publica'
        WHEN dc.holder_legal_personality = 'privada_sin_fin_de_lucro' OR dc.has_paliative_places = 'true' 
            THEN 'Residencia privada sin lucro'
        ELSE 'Resto de residencias'
	    END
	) AS titularity,
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
    dc.center_name,
    dc.has_autonomous_places,
    dc.has_psychogeriatric_places,
    dc.has_paliative_places,
    dc.holder_legal_personality,
    dc.restriction_free_center;