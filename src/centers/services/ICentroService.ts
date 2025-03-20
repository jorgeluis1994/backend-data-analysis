export interface ICentroService {
  //obtener metricas por id centro
  getCenterUsersAvg( id: string, metric: string): Promise<any>;
  //obtener metricas por todos centro
  getCenterUsersAvgAll( metric: string): Promise<any>;

  //obtener metricas por tipo de centro
  getCenterTypeAll(): Promise<any>;

  //obtener metricas por tipo de centro
  getCenterRestricAll(): Promise<any>;

  getMetricByCharacteristics(caracteristic:string,group:string):Promise<any>;


}