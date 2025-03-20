CREATE OR REPLACE FUNCTION _get_indicator_people(caracteristica TEXT)
RETURNS TABLE(center_type TEXT, total_residentes INT, promedio NUMERIC, desviacion_estandar NUMERIC) AS $$
DECLARE
  column_exists BOOLEAN;
BEGIN
  -- Verificar si la característica proporcionada existe como columna en la tabla dim_people
  EXECUTE '
    SELECT EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_name = ''dim_people'' AND column_name = $1
    )' INTO column_exists USING caracteristica;

  -- Si la característica no existe, lanzar un error
  IF NOT column_exists THEN
    RAISE EXCEPTION 'La característica "%" no es válida en la tabla dim_people', caracteristica;
  END IF;

  -- Si la característica es válida, proceder con la consulta
  RETURN QUERY
  EXECUTE '
    SELECT 
        dc.center_type::TEXT, 
        COUNT(dp.person_identifier)::INTEGER AS total_residentes,
        ROUND(AVG(COALESCE(dp."' || caracteristica || '"::NUMERIC, 0))::NUMERIC, 1) AS promedio,
        ROUND(STDDEV(COALESCE(dp."' || caracteristica || '"::NUMERIC, 0))::NUMERIC, 1) AS desviacion_estandar
    FROM dim_people dp
    JOIN dim_centers dc ON dp.center_identifier = dc.center_identifier
    GROUP BY dc.center_type;
  ';
END;
$$ LANGUAGE plpgsql;


select * from _get_indicator_people('age')	

select dp.age,dp.height_cm,dp.last_weight from dim_people dp 