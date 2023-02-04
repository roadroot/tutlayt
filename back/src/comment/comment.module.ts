import { Module } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CommentResolver } from './comment.resolver';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuestionModule } from 'src/question/question.module';
import { UserModule } from 'src/user/user.module';
import { forwardRef } from '@nestjs/common/utils';
import { StorageModule } from 'src/storage/storage.module';

@Module({
  imports: [
    PrismaModule,
    QuestionModule,
    forwardRef(() => UserModule),
    StorageModule,
  ],
  providers: [CommentService, CommentResolver],
  exports: [CommentService],
})
export class CommentModule {}
