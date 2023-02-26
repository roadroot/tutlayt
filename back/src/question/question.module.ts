import { forwardRef, Module } from '@nestjs/common';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaModule } from 'src/prisma/prisma.module';
import { StorageModule } from 'src/storage/storage.module';
import { UserModule } from 'src/user/user.module';
import QuestionResolver from './question.resolver';
import { QuestionService } from './question.service';

@Module({
  imports: [
    forwardRef(() => UserModule),
    PrismaModule,
    forwardRef(() => AuthModule),
    StorageModule,
  ],
  providers: [QuestionService, QuestionResolver],
  exports: [QuestionService],
})
export class QuestionModule {}
