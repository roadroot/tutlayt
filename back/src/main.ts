import { NestFactory } from '@nestjs/core';
import { ForbiddenError } from 'apollo-server-express';
import { graphqlUploadExpress } from 'graphql-upload-ts/dist/graphqlUploadExpress';
import helmet from 'helmet';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.enableCors({
    origin: function (origin, callback) {
      const whitelist = process.env.API_CORS_WHITELIST.split(',');
      // origin mathes regex in whitelist
      if (whitelist.some((item) => new RegExp(item).test(origin)) || !origin) {
        callback(null, true);
      } else {
        callback(new ForbiddenError('Not allowed by CORS'));
      }
    },
  });
  if (process.env.NODE_ENV === 'production') {
    app.use(helmet());
  } else {
    app.use(
      helmet({
        contentSecurityPolicy: false,
        crossOriginEmbedderPolicy: false,
      }),
    );
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
