import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserResolver } from './user.resolver';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuestionModule } from 'src/question/question.module';

@Module({
  imports: [PrismaModule, QuestionModule],
  providers: [UserService, UserResolver],
  exports: [UserService],
})
export class UserModule {}
