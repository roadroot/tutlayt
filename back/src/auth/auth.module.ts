import { UserModule } from './../user/user.module';
import { LocalStrategy } from './strategy/local/local.strategy';
import { Module } from '@nestjs/common';
import { AuthService } from './service/auth.service';
import { PassportModule } from '@nestjs/passport';
import { LocalAuthGuard } from './strategy/local/local.guard';
import { JwtStrategy } from './strategy/jwt/jwt.strategy';
import { JwtAuthGuard } from './strategy/jwt/jwt.guard';
import { JwtModule } from '@nestjs/jwt';
import { CredentialService } from 'src/auth/service/credential.service';
import { PrismaModule } from 'src/prisma/prisma.module';

@Module({
  imports: [
    PassportModule,
    JwtModule.register({
      secret: 'process.env.JWT_SECRET_KEY',
      signOptions: { expiresIn: process.env.JWT_LIFE_SPAN },
    }),
    UserModule,
    PrismaModule,
  ],
  providers: [
    CredentialService,
    AuthService,
    LocalStrategy,
    LocalAuthGuard,
    JwtStrategy,
    JwtAuthGuard,
  ],
  exports: [AuthService, LocalAuthGuard, JwtAuthGuard],
})
export class AuthModule {}
