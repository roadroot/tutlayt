import { Module } from '@nestjs/common';
import { forwardRef } from '@nestjs/common/utils';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuestionModule } from 'src/question/question.module';
import { StorageModule } from 'src/storage/storage.module';
import { UserModule } from 'src/user/user.module';
import { CommentResolver } from './comment.resolver';
import { CommentService } from './comment.service';

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
