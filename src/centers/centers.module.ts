import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DimCenter } from './models/center.entity';
import { CentersController } from './controllers/CentersController';
import { CenterService } from './services/imp/CenterService';
import { DimPeople } from './models/people.entity';

@Module({
    imports:[TypeOrmModule.forFeature([DimCenter,DimPeople])],
    providers:[CenterService],
    controllers:[CentersController]
})
export class CentersModule {}
