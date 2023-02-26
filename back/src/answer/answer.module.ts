import { forwardRef, Module } from '@nestjs/common';
import { PrismaModule } from 'src/prisma/prisma.module';
import { StorageModule } from 'src/storage/storage.module';
import { UserModule } from 'src/user/user.module';
import AnswerResolver from './answer.resolver';
import { AnswerService } from './answer.service';

@Module({
  imports: [forwardRef(() => UserModule), PrismaModule, StorageModule],
  providers: [AnswerService, AnswerResolver],
  exports: [AnswerService],
})
export class AnswerModule {}
