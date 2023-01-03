import { UserService } from '../user/user.service';
import { PrismaService } from './../prisma/prisma.service';
import { Module } from '@nestjs/common';
import { CredentialService } from './credential.service';

@Module({
  providers: [CredentialService, PrismaService, UserService],
  exports: [CredentialService],
})
export class CredentialModule {}
