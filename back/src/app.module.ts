import { ApolloDriverConfig } from '@nestjs/apollo';
import { ApolloDriver } from '@nestjs/apollo/dist/drivers';
import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { join } from 'path';
import { AnswerModule } from './answer/answer.module';
import { AuthModule } from './auth/auth.module';
import { CredentialService } from './auth/service/credential.service';
import { CommentModule } from './comment/comment.module';
import { PrismaModule } from './prisma/prisma.module';
import { QuestionModule } from './question/question.module';
import { StorageModule } from './storage/storage.module';
import { UserModule } from './user/user.module';

const myPlugin = {
  // Fires whenever a GraphQL request is received from a client.
  async requestDidStart(requestContext) {
    console.log('Request started! Query:\n' + requestContext.request.query);
    return {
      async didEncounterErrors(requestContext) {
        console.log(`Encountered errors! ${requestContext.errors}`);
      },
    };
  },
};

@Module({
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      context: ({ req }) => ({ req }),
      autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
      plugins: process.env.API_LOG_REQUESTS == 'true' ? [myPlugin] : [],
      playground: {
        settings: {
          'schema.polling.enable': false,
        },
      },
    }),
    PrismaModule,
    AuthModule,
    UserModule,
    QuestionModule,
    AnswerModule,
    StorageModule,
    CommentModule,
  ],
  providers: [CredentialService],
})
export class AppModule {}
