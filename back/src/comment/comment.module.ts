import { Module } from '@nestjs/common';
import { CommentService } from './comment.service';
import { CommentResolver } from './comment.resolver';

@Module({
  providers: [CommentService, CommentResolver],
})
export class CommentModule {}
