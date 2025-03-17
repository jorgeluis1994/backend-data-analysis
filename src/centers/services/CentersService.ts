import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DimCenter } from '../models/center.entity'; // Asegúrate de que la entidad Center esté definida correctamente
import { DimPeople } from '../models/people.entity';

@Injectable()
export class CentersService {
  constructor(
    @InjectRepository(DimCenter)
    private readonly centerRepository: Repository<DimCenter>,
    @InjectRepository(DimPeople)
    private readonly peopleRepository: Repository<DimPeople>,
  ) {}

  async getTotalUsuariosPorCentro(): Promise<any> {

    const query = `
      select * from catalog_statistics_centers csc limit 4
    `;
    
    const results = await this.centerRepository.query(query);

    const series = results.map((row: any) => {
      return {
        name: row.center_name.toUpperCase(),  
        data: [
          parseFloat(row.total_users)  
        ],
      };
    });
    
    return series;
  }
  
  
  
}
