import { forwardRef, Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { CredentialService } from 'src/auth/service/credential.service';
import { PrismaModule } from 'src/prisma/prisma.module';
import { UserModule } from './../user/user.module';
import { AuthService } from './service/auth.service';
import { JwtAuthGuard } from './strategy/jwt/jwt.guard';
import { JwtStrategy } from './strategy/jwt/jwt.strategy';
import { LocalAuthGuard } from './strategy/local/local.guard';
import { LocalStrategy } from './strategy/local/local.strategy';

@Module({
  imports: [
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_TOKEN_SECRET_KEY,
      signOptions: { expiresIn: process.env.JWT_TOKEN_LIFE_SPAN },
    }),
    forwardRef(() => UserModule),
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
