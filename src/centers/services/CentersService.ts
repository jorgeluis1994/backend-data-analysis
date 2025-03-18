import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DimCenter } from '../models/center.entity'; // Asegúrate de que la entidad Center esté definida correctamente
import { DimPeople } from '../models/people.entity';
import { DataSourceItem } from '../models/centerIndicator';

@Injectable()
export class CentersService {
  constructor(
    @InjectRepository(DimCenter)
    private readonly centerRepository: Repository<DimCenter>,
    @InjectRepository(DimPeople)
    private readonly peopleRepository: Repository<DimPeople>,
  ) {}

  async getTotalUsuariosPorCentro(): Promise<any> {
    try {
      const query = `SELECT * FROM catalog_statistics_centers csc LIMIT 4`;
      const results = await this.centerRepository.query(query);
  
      // Transformar los datos en el formato adecuado
      const series = results.map((row: any) => ({
        name: row.center_name.toUpperCase(),
        data: [parseFloat(row.total_users)],
      }));
  
      return series;
    } catch (error) {
      console.error('Error al obtener total de usuarios por centro:', error);
      throw new Error('No se pudo obtener la información de los centros.');
    }
  }
  async getIndicatorByCenter(id: string): Promise<any> {
    
    const query = `select * from catalog_statistics_centers csc limit 1`;
  
    try {
      const results = await this.centerRepository.query(query);
  
      if (results.length === 0) throw new Error('No results found.');
  
      return results.flatMap((center) => [
        { name: 'Number of users', weight: parseInt(center.total_users, 10) },
        { name: '% Valid', weight: parseFloat(center.valid_data_percentage) },
        { name: 'Indicator', weight: parseFloat(center.average_age) },
        { name: 'Standard Deviation', weight: parseFloat(center.stddev_age) },
      ]);
      
    } catch (error) {
      console.error('Error fetching data:', error);
      throw new Error('Error fetching data from the database');
    }
  }
  
  

  

  // Método para obtener indicadores por el ID del centro
  async getIndicatorByCenterId(id: string): Promise<DataSourceItem[]> {
    const query = `
      SELECT * FROM catalog_statistics_centers csc
      WHERE csc.center_id = $1  -- Aquí se filtra por el ID del centro
      LIMIT 1
    `;
    const results = await this.centerRepository.query(query, [id]);

    if (!results || results.length === 0) {
      return null; // Retorna null si no se encuentran datos
    }

    // Mapea los resultados según el formato de DataSourceItem
    return results
      .map((center, index) => [
        {
          position: index + 1,
          name: 'Numero de usuarios',
          weight: center.total_users,
        },
        {
          position: index + 2,
          name: 'Casoso sin info',
          weight: center.total_over_60,
        },
        {
          position: index + 3,
          name: '% Valido',
          weight: center.valid_data_percentage,
        },
        { position: index + 4, name: 'Indicador', weight: center.average_age },
        {
          position: index + 5,
          name: 'Desviacion Estandar',
          weight: center.stddev_age,
        },
      ])
      .flat();
  }
}
