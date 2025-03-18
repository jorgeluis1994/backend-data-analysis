import { ApiProperty } from '@nestjs/swagger';

export class ResponseDTO<T> {
  @ApiProperty({ description: 'Código de estado HTTP', example: 200 })
  statusCode: number;

  @ApiProperty({ description: 'Mensaje de la respuesta', example: 'Operación exitosa' })
  message: string;

  @ApiProperty({ description: 'Los datos devueltos', example: {} })
  data?: T; // Se mantiene genérico para cualquier tipo de dato
}
