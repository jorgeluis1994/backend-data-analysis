import { Controller, Get } from '@nestjs/common';
import { CentersService } from '..//services/CentersService';

@Controller('centers/totals') // Ruta para acceder a los centros
export class CentersController {


  constructor(private readonly centersService: CentersService) {}

  // Ruta para obtener todos los centros
  @Get()
  getCenters() {
    return this.centersService.getTotalUsuariosPorCentro();// Llama al método en el servicio para obtener los centros
  }
}
