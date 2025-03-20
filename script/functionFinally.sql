--Center depurados
CREATE VIEW view_centers AS
SELECT
   c.center_identifier,
   UPPER(c.center_name) AS center_name,
   c.holder_cif_nif,
   UPPER(c.holder_legal_personality) AS holder_legal_personality,
   C.manager_cif_nif,
   UPPER(c.manager_legal_personality) AS manager_legal_personality,
   UPPER(c.center_type) AS center_type,
   UPPER(C.municipality) AS municipality,
   UPPER(C.restriction_free_center) AS restriction_free_center_,
   CASE 
      WHEN c.restriction_free_center = 'si' THEN 'SIN RESTRICCIONES'
      WHEN c.restriction_free_center = 'no' THEN 'CON RESTRICCIONES'
      ELSE 'RESTO'
   END AS restriction_free_center,
   CASE 
      WHEN c.num_authorized_places = -1 THEN 0
      ELSE c.num_authorized_places
   END AS num_authorized_places,
   CASE 
      WHEN c.num_contracted_places = -1 THEN 0
      ELSE c.num_contracted_places
   END AS num_contracted_places,
   CASE 
      WHEN c.num_contracted_places > 0 THEN 'PLAZAS CONCERTADAS'
      ELSE 'SIN PLAZAS CONCERTADAS'
   END AS contracted_status,
   CASE 
      WHEN c.num_contracted_places > 0 AND c.num_contracted_places <= 30 THEN '0 a 30 PLAZAS CONCERTADAS'
      WHEN c.num_contracted_places > 30 AND c.num_contracted_places <= 59 THEN '30 a 59 PLAZAS CONCERTADAS'
      WHEN c.num_contracted_places > 59 THEN '60 o más PLAZAS CONCERTADAS'
      ELSE 'SIN PLAZAS CONCERTADAS'
   END AS contracted_status_range,  -- Renombrado para evitar duplicados
   CASE 
      WHEN c.has_psychogeriatric_places = 'si' OR c.has_paliative_places = 'si' THEN 'PALIATIVOS/SICOGERIATRIA'
      WHEN c.has_autonomous_places = 'si' THEN 'AUTÓNOMAS'
      ELSE 'RESTO'
   END AS type_
FROM
   centers c
ORDER BY
   c.center_name ASC;

--People depurado
CREATE VIEW view_peoples as
SELECT
    p.center_identifier,
    p.person_identifier,
    UPPER(p.gender),
    TO_CHAR(TO_TIMESTAMP(p.date_of_birth / 1000), 'DD-MM-YYYY') AS date_of_birth,
    CASE 
        WHEN p.reference_bvd_score = -1 THEN 0 
        ELSE p.reference_bvd_score 
    END AS reference_bvd_score,
    CASE 
        WHEN p.bvd_score_on_admission = -1 THEN 0 
        ELSE p.bvd_score_on_admission 
    END AS bvd_score_on_admission,
    CASE 
        WHEN p.modified_barthel_score = -1 THEN 0 
        ELSE p.modified_barthel_score 
    END AS modified_barthel_score,
    EXTRACT(YEAR FROM AGE(TO_TIMESTAMP(p.date_of_birth / 1000))) AS age,
    CASE 
        WHEN p.height_cm = -1 THEN 0 
        ELSE p.height_cm 
    END AS height_cm,
    CASE 
        WHEN p.last_weight = -1 THEN 0 
        ELSE p.last_weight 
    END AS weight_kg,
    -- Cálculo del IMC con CAST explícito y COALESCE para reemplazar NULL por 0
    COALESCE(
        CASE 
            WHEN p.height_cm <= 0 OR p.last_weight <= 0 THEN NULL  -- Evitar división por cero o valores negativos
            ELSE ROUND((p.last_weight / POWER(p.height_cm / 100.0, 2))::numeric, 2)  -- CAST explícito a numeric
        END, 
        0  -- Si es NULL, devuelve 0
    ) AS imc,
    -- Clasificación del IMC como "alto", "bajo" o "normal"
    UPPER(CASE
        WHEN COALESCE(
                CASE 
                    WHEN p.height_cm <= 0 OR p.last_weight <= 0 THEN NULL
                    ELSE ROUND((p.last_weight / POWER(p.height_cm / 100.0, 2))::numeric, 2)
                END, 0
            ) >= 30 THEN 'Alto'
        WHEN COALESCE(
                CASE 
                    WHEN p.height_cm <= 0 OR p.last_weight <= 0 THEN NULL
                    ELSE ROUND((p.last_weight / POWER(p.height_cm / 100.0, 2))::numeric, 2)
                END, 0
            ) <= 18.5 THEN 'Bajo'
        ELSE 'Normal'
    end) AS imc_category,
    TO_CHAR(TO_TIMESTAMP(p.admission_date / 1000), 'DD-MM-YYYY') AS admission_date,
    TO_CHAR(TO_TIMESTAMP(p.last_functional_assessment_date / 1000), 'DD-MM-YYYY') AS last_functional_assessment_date,
    TO_CHAR(TO_TIMESTAMP(p.last_weighing_date / 1000), 'DD-MM-YYYY') AS last_weighing_date,
    TO_CHAR(TO_TIMESTAMP(p.date_second_last_weighing / 1000), 'DD-MM-YYYY') AS date_second_last_weighing,
    TO_CHAR(TO_TIMESTAMP(p.last_bvd_date / 1000), 'DD-MM-YYYY') AS last_bvd_date,
    UPPER(p.stay_type) as stay_type,
    UPPER(p.occupied_place_type) as occupied_place_type,
    UPPER(p."fecal_incontinence ") as fecal_incontinence,
    UPPER(p.vascular_disease)as vascular_disease,
    UPPER(p.peripheral_arterial_disease)as peripheral_arterial_disease,
    UPPER(p.diabetes)as diabetes,
    UPPER(p.difficulty_changing_position) as difficulty_changing_position
FROM
    people p;

--Funcion para calculo de promedio en base a group y caracteristica
CREATE OR REPLACE FUNCTION _get_indicator_people_center_group_(
    caracteristica TEXT,
    group_by_column TEXT
)
RETURNS TABLE(
    group_value TEXT,
    total_residentes INT,
    promedio NUMERIC,
    desviacion_estandar NUMERIC
) AS $$
DECLARE
    column_exists BOOLEAN;
    group_column_exists BOOLEAN;
    sql_query TEXT;
BEGIN
    -- Verificar si la característica proporcionada existe en la tabla view_peoples
    EXECUTE '
        SELECT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_name = ''view_peoples'' AND column_name = $1
        )' INTO column_exists USING caracteristica;

    -- Si la característica no existe, lanzar un error
    IF NOT column_exists THEN
        RAISE EXCEPTION 'La característica "%" no es válida en la vista view_peoples', caracteristica;
    END IF;

    -- Verificar si la columna para agrupar existe en la vista view_centers
    EXECUTE '
        SELECT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_name = ''view_centers'' AND column_name = $1
        )' INTO group_column_exists USING group_by_column;

    -- Si la columna de agrupación no existe, lanzar un error
    IF NOT group_column_exists THEN
        RAISE EXCEPTION 'La columna de agrupación "%" no es válida en la vista view_centers', group_by_column;
    END IF;

    -- Construcción de la consulta dinámica
    sql_query := format('
        SELECT 
            vc.%I::TEXT AS group_value,
            COUNT(dp.person_identifier)::INTEGER AS total_residentes,
            ROUND(AVG(COALESCE(dp.%I::NUMERIC, 0))::NUMERIC, 1) AS promedio,
            ROUND(STDDEV(COALESCE(dp.%I::NUMERIC, 0))::NUMERIC, 1) AS desviacion_estandar
        FROM view_peoples dp
        JOIN view_centers vc ON dp.center_identifier = vc.center_identifier
        GROUP BY vc.%I;',
        group_by_column, caracteristica, caracteristica, group_by_column);

    -- Ejecutar la consulta y retornar los resultados
    RETURN QUERY EXECUTE sql_query;
END;
$$ LANGUAGE plpgsql;

select * from _get_indicator_people_center_group_('last_weight','center_type');

last_weight restriction_free_center

select vc.contracted_status_range from view_centers vc 

select vp.fecal_incontinence from view_peoples vp 

select vc.type_     from view_centers vc 


-- height 
--imc
--weight_kg 
--age 
--modified_barthel_score
--center_type
--municipality
--restriction_free_center
