import { PrismaModule } from './../prisma/prisma.module';
import { UserModule } from '../user/user.module';
import { Module, forwardRef } from '@nestjs/common';
import { QuestionService } from './question.service';
import QuestionResolver from './question.resolver';

@Module({
  imports: [forwardRef(() => UserModule), PrismaModule],
  providers: [QuestionService, QuestionResolver],
  exports: [QuestionService],
})
export class QuestionModule {}
