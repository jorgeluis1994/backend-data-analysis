import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { DimCenter } from "src/centers/models/center.entity";
import { Repository } from "typeorm";
import { ICentroService } from "../ICentroService";

@Injectable()
export class CenterService implements ICentroService{

    constructor( 

                 @InjectRepository(DimCenter) private readonly centerRepository: Repository<DimCenter>
                 
               ) {}

               
  
    async getCenterUsersAvgAll(metric: string): Promise<any> {
        try {
            const query = `
                            SELECT * FROM get_center_user_stats_all($1) LIMIT 4;
                            
                          `;
            const results = await this.centerRepository.query(query, [metric]);

            if (results.length === 0) {
                return { message: "No se encontraron datos." };
            }

            const series=results.map((serie)=>{

                 return {
                    name: serie.center_name ,
                    data: [serie.value ] 
                  }

            });

            return series;
        } catch (error) {
            
        }
    }

    async getCenterUsersAvg(id: string,metric: string): Promise<any> {
        try {
            const query = `
                            SELECT * FROM get_center_user_stats($1, $2);
                          `;
    
            const results = await this.centerRepository.query(query, [id, metric]);

            if (results.length === 0) {
                return { message: "No se encontraron datos." };
            }

            const serie=[{
                name: results[0].center_name ,
                data: [results[0].value ] 
              }]

            return serie;
            
        } catch (error) {
            
        }
    }

    async getCenterTypeAll(): Promise<any> {
        try {
            const query = `
                            SELECT * FROM get_center_stats();
                          `;
            const results = await this.centerRepository.query(query);

            const series=results.map((serie)=>{

                return {
                   name: serie.type_restric  ,
                   data: [serie.promedio_edad ] 
                 }

           });
           return series;
           
        } catch (error) {
            
        }
    }

    async getCenterRestricAll(): Promise<any> {
         try {
            
        
         } catch (error) {
            
         }
    }

    async getMetricByCharacteristics(caracteristic: string,group:string): Promise<any[]> {
        try {
            console.log('Característica recibida:', caracteristic);
            
            const query = `SELECT * FROM _get_indicator_people_center_group_($1,$2)`;
            const results = await this.centerRepository.query(query, [caracteristic,group]);
    
            console.log('Resultados:', results);

            const series=results.map((serie)=>{

                return {
                   name: serie.group_value,
                   data: [serie.promedio ] 
                 }

           });

        
           return series;
            
        } catch (error) {
            console.error('Error al obtener métricas:', error);
            throw new Error('No se pudo obtener las métricas'); // Lanza un error manejable
        }
    }
    

}