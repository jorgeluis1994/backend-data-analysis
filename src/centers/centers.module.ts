import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DimCenter } from './models/center.entity';
import { CentersService } from './services/CentersService';
import { CentersController } from './controllers/CentersController';
import { DimPeople } from './models/people.entity';

@Module({
    imports:[TypeOrmModule.forFeature([DimCenter,DimPeople])],
    providers:[CentersService],
    controllers:[CentersController]
})
export class CentersModule {}
