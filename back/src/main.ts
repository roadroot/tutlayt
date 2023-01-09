import { FastifyAdapter } from '@nestjs/platform-fastify';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { log } from 'console';

async function bootstrap() {
  log(process.env.JWT_SECRET_KEY);
  const app = await NestFactory.create(AppModule, new FastifyAdapter());
  await app.listen(process.env.SERVER_PORT);
}
bootstrap();
