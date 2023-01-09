import { Module } from '@nestjs/common';
import { GraphQLModule } from '@nestjs/graphql';
import { MercuriusDriver, MercuriusDriverConfig } from '@nestjs/mercurius';
import { join } from 'path';
import { AuthModule } from './auth/auth.module';
import { CredentialService } from './auth/service/credential.service';
import { UserModule } from './user/user.module';
import { PrismaModule } from './prisma/prisma.module';
import { QuestionModule } from './question/question.module';

@Module({
  imports: [
    GraphQLModule.forRoot<MercuriusDriverConfig>({
      driver: MercuriusDriver,
      graphiql: true,
      context: ({ req }) => ({ req }),
      autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
    }),
    PrismaModule,
    AuthModule,
    UserModule,
    QuestionModule,
  ],
  providers: [CredentialService],
})
export class AppModule {}
