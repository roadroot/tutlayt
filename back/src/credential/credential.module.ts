import { UsersService } from './../users/users.service';
import { PrismaService } from './../prisma/prisma.service';
import { Module } from '@nestjs/common';
import { CredentialService } from './credential.service';

@Module({
  providers: [CredentialService, PrismaService, UsersService],
})
export class CredentialModule {}
