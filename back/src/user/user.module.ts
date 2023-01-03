import { QuestionModule } from './../question/question.module';
import { PrismaModule } from '../prisma/prisma.module';
import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import UserResolver from './user.resolver';

@Module({
  imports: [PrismaModule, QuestionModule],
  providers: [UserService, UserResolver],
  exports: [UserService],
})
export class UserModule {}
