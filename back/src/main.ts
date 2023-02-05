import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { graphqlUploadExpress } from 'graphql-upload-ts/dist/graphqlUploadExpress';
import helmet from 'helmet';
import { ForbiddenError } from 'apollo-server-express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: function (origin, callback) {
      const whitelist = process.env.API_CORS_WHITELIST.split(',');
      if (whitelist.indexOf(origin) !== -1 || !origin) {
        callback(null, true);
      } else {
        callback(new ForbiddenError('Not allowed by CORS'));
      }
    },
  });
  if (process.env.NODE_ENV === 'production') {
    app.use(helmet());
  } else {
    app.use(helmet({ contentSecurityPolicy: false }));
  }
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
