import { Module } from '@nestjs/common';
import { CentersModule } from './centers/centers.module';
import { TypeOrmModule } from '@nestjs/typeorm';  // Importa TypeOrmModule
import { DimCenter } from './centers/models/center.entity';
import { DimPeople } from './centers/models/people.entity';

@Module({
  imports: [ TypeOrmModule.forRoot({
    type: 'postgres',  
    host: 'javierjamaica.com',  
    port: 3809,  
    username: 'govtech_adm', 
    password: 'govtech1234', 
    database: 'govtech', 
    entities: [DimCenter,DimPeople], 
    synchronize: true, 
    logging: true
  }),CentersModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
