import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // Configuración de Swagger
  const config = new DocumentBuilder()
    .setTitle('DataAnalysisModule')
    .setDescription(
      'Documentación de la API para la consulta de grafico y otros endpoints',
    ) // Descripción
    .setVersion('1.0')
    .addTag('reportes')
    .addBearerAuth()
    .build();

  // Crear el documento Swagger
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);
  // Habilitar CORS globalmente
  app.enableCors();

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
