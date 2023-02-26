import { forwardRef, Module } from '@nestjs/common';
import { AnswerModule } from 'src/answer/answer.module';
import { CommentModule } from 'src/comment/comment.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuestionModule } from 'src/question/question.module';
import { StorageModule } from 'src/storage/storage.module';
import { UserResolver } from './user.resolver';
import { UserService } from './user.service';

@Module({
  imports: [
    PrismaModule,
    QuestionModule,
    StorageModule,
    forwardRef(() => AnswerModule),
    CommentModule,
  ],
  providers: [UserService, UserResolver],
  exports: [UserService],
})
export class UserModule {}
