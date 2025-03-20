import { Controller, Get, Param } from '@nestjs/common';
import { CenterService } from '../services/imp/CenterService';

@Controller('centers') 
export class CentersController {

  constructor(private readonly _centersService: CenterService) {}

  // @Get(':id/:metric')
  // getCenterById( @Param('id') id:string,@Param('metric') metric:string   ){
  //   return this._centersService.getCenterUsersAvg(id,metric);
  // }

  // @Get(':metric')
  // getCenterByIdAll( @Param('metric') metric:string   ){
  //   return this._centersService.getCenterUsersAvgAll(metric);
  // }

  // @Get()
  // getCenterRestricAll(){
  //   return this._centersService.getCenterTypeAll()
  // }

  @Get(':caracteristic')
  getindicator(@Param('caracteristic') caracteristic:string){
    return this._centersService.getMetricByCharacteristics(caracteristic);
  }
}
