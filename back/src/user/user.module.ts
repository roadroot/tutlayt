import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserResolver } from './user.resolver';
import { PrismaModule } from 'src/prisma/prisma.module';
import { QuestionModule } from 'src/question/question.module';
import { StorageModule } from 'src/storage/storage.module';

@Module({
  imports: [PrismaModule, QuestionModule, StorageModule],
  providers: [UserService, UserResolver],
  exports: [UserService],
})
export class UserModule {}
