import { LocalStrategy } from './local.strategy';
import { UsersModule } from './../users/users.module';
import { CredentialService } from './../credential/credential.service';
import { UsersService } from './../users/users.service';
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { PassportModule } from '@nestjs/passport';

@Module({
  imports: [UsersModule, PassportModule],
  providers: [UsersService, AuthService, CredentialService, LocalStrategy],
  exports: [AuthService],
})
export class AuthModule {}
