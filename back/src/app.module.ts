import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { join } from 'path';
import { AuthModule } from './auth/auth.module';
import { CredentialService } from './auth/service/credential.service';
import { UserModule } from './user/user.module';
import { PrismaModule } from './prisma/prisma.module';
import { QuestionModule } from './question/question.module';
import { ApolloDriverConfig } from '@nestjs/apollo';
import { ApolloDriver } from '@nestjs/apollo/dist/drivers';
import { StorageModule } from './storage/storage.module';
import { ApolloServerPlugin } from 'apollo-server-plugin-base';

const myPlugin: ApolloServerPlugin = {
  // Fires whenever a GraphQL request is received from a client.
  async requestDidStart(requestContext) {
    console.log('Request started! Query:\n' + requestContext.request.query);

    return {
      async didEncounterErrors(requestContext) {
        console.log(
          `Encountered errors! ${JSON.stringify(requestContext.errors)}`,
        );
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
    }),
    PrismaModule,
    AuthModule,
    UserModule,
    QuestionModule,
    StorageModule,
  ],
  providers: [CredentialService],
})
export class AppModule {}
