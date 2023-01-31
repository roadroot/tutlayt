import { Module, forwardRef } from '@nestjs/common';
import { AnswerService } from './answer.service';
import AnswerResolver from './answer.resolver';
import { UserModule } from 'src/user/user.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { StorageModule } from 'src/storage/storage.module';

@Module({
  imports: [forwardRef(() => UserModule), PrismaModule, StorageModule],
  providers: [AnswerService, AnswerResolver],
  exports: [AnswerService],
})
export class AnswerModule {}
