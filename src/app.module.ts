import { Module } from '@nestjs/common';
import { CentersModule } from './centers/centers.module';
import { TypeOrmModule } from '@nestjs/typeorm';  // Importa TypeOrmModule
import { DimCenter } from './centers/models/center.entity';
import { DimPeople } from './centers/models/people.entity';

@Module({
  imports: [ TypeOrmModule.forRoot({
    type: 'postgres',  
    host: '173.249.10.18',  
    port: 5432,  
    username: 'smc_user', 
    password: 'T€$t1Ng', 
    database: 'smc_bigdata', 
    entities: [DimCenter,DimPeople], 
    synchronize: false, 
    logging: true
  }),CentersModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
