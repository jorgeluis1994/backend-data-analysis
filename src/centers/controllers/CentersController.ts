import { Controller, Get, Param } from '@nestjs/common';
import { CentersService } from '..//services/CentersService';
import { DataSourceItem } from '../models/centerIndicator';
import { ApiResponse } from '@nestjs/swagger';
import { ResponseDTO } from '../DTOs/response.dto';

@Controller('centers/') 
export class CentersController {

    constructor(private readonly centersService: CentersService) {}

    @Get()
    @ApiResponse({
      status: 200,
      description: 'Lista de centros con usuarios',
      type: ResponseDTO,
    })
    async getCenters(): Promise<ResponseDTO<{ name: string; data: number[] }[]>> {
      try {
        const data = await this.centersService.getTotalUsuariosPorCentro();
        return {
          statusCode: 200,
          message: 'Operación exitosa',
          data,
        };
      } catch (error) {
        return {
          statusCode: 500,
          message: 'Error al obtener los datos',
          data: [],
        };
      }
    }


    @Get('indicator/:id')
    @Get()
    @ApiResponse({
      status: 200,
      description: 'Lista de centros con usuarios',
      type: ResponseDTO,
    })
    async getCentersIndicator(@Param('id') id: string): Promise<ResponseDTO<{ name: string; data: number[] }[]>> {
          try {
          const data = await this.centersService.getIndicatorByCenter(id); 
          return {
            statusCode: 200,
            message: 'Operación exitosa',
            data,
          };
        } catch (error) {
          return {
            statusCode: 500,
            message: 'Error al obtener los datos',
            data: [],
          };
        }
      }

}
