import { CredentialModule } from './../credential/credential.module';
import { LocalStrategy } from './local.strategy';
import { UserModule } from '../user/user.module';
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { PassportModule } from '@nestjs/passport';

@Module({
  imports: [UserModule, PassportModule, UserModule, CredentialModule],
  providers: [AuthService, LocalStrategy],
  exports: [AuthService],
})
export class AuthModule {}
