import { Controller, Get, Param } from '@nestjs/common';
import { CenterService } from '../services/imp/CenterService';

@Controller('centers') 
export class CentersController {

  constructor(private readonly _centersService: CenterService) {}

  @Get(':caracteristic/:group')
  getindicator(@Param('caracteristic') characteristic: string, @Param('group') group: string) {
    return this._centersService.getMetricByCharacteristics(characteristic, group);
  }

}
