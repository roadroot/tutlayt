import { ApolloDriverConfig } from "@nestjs/apollo";
import { ApolloDriver } from "@nestjs/apollo/dist/drivers";
import { Logger, Module } from "@nestjs/common";
import { GraphQLModule } from "@nestjs/graphql";
import { join } from "path";
import { AnswerModule } from "./answer/answer.module";
import { AuthModule } from "./auth/auth.module";
import { CommentModule } from "./comment/comment.module";
import { PrismaModule } from "./prisma/prisma.module";
import { QuestionModule } from "./question/question.module";
import { StorageModule } from "./storage/storage.module";
import { UserModule } from "./user/user.module";
import { ApolloServerPlugin } from "@apollo/server";

const logger = new Logger("AppModule");

const myPlugin: ApolloServerPlugin = {
  // Fires whenever a GraphQL request is received from a client.
  async requestDidStart(requestContext) {
    logger.verbose("Request started! Query:\n" + requestContext.request.query);
    return {
      async didEncounterErrors(requestContext) {
        logger.error(`Encountered errors! ${requestContext.errors}`);
      },
    };
  },
};

@Module({
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: join(process.cwd(), "src/schema.gql"),
      installSubscriptionHandlers: true,
      subscriptions: {
        // TODO replace with graphql-ws
        "subscriptions-transport-ws": {
          path: "/graphql",
        },
      },
      context: ({ req }) => ({ req }),
      plugins: process.env.API_LOG_REQUESTS == "true" ? [myPlugin] : [],
      playground: {
        settings: {
          "schema.polling.enable": false,
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
})
export class AppModule {}
