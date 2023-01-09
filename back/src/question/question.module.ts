import { Module, forwardRef } from '@nestjs/common';
import { QuestionService } from './question.service';
import QuestionResolver from './question.resolver';
import { UserModule } from 'src/user/user.module';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  imports: [forwardRef(() => UserModule), PrismaModule],
  providers: [QuestionService, QuestionResolver],
  exports: [QuestionService],
})
export class QuestionModule {}
