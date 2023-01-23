import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { graphqlUploadExpress } from 'graphql-upload-ts/dist/graphqlUploadExpress';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: false }); // TODO add cors
  app.use(
    graphqlUploadExpress({
      maxFieldSize: parseInt(process.env.API_UPLOADS_MAX_FILESIZE),
      maxFileSize: parseInt(process.env.API_UPLOADS_MAX_FILESIZE),
      maxFiles: parseInt(process.env.API_UPLOADS_MAX_FILES),
    }),
  );
  await app.listen(process.env.SERVER_PORT);
}
bootstrap();
