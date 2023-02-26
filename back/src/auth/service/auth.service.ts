import { Injectable, UnauthorizedException } from '@nestjs/common';
import { Args, Mutation } from '@nestjs/graphql';
import { JwtService } from '@nestjs/jwt';
import { RegisterParam } from 'src/user/model/register.param';
import { UserDTO } from 'src/user/model/user.model';
import { UserService } from '../../user/user.service';
import { LoginParam } from '../model/login.param';
import { Token } from '../model/token.model';
import { CredentialService } from './credential.service';

@Injectable()
export class AuthService {
  constructor(
    private readonly user: UserService,
    private readonly cred: CredentialService,
    private readonly jwt: JwtService,
  ) {}

  async validateUser(
    username: string,
    password: string,
  ): Promise<UserDTO | null> {
    const user = await this.user.getUser({
      username,
    });
    return user && (await this.cred.verifyPassword(user.id, password))
      ? user
      : null;
  }

  @Mutation(() => Token)
  async login(
    @Args('data', { type: () => LoginParam }) credentials: LoginParam,
  ): Promise<Token> {
    const user = await this.validateUser(
      credentials.username,
      credentials.password,
    );
    if (user === null) {
      throw new UnauthorizedException();
    }
    return {
      token: await this.jwt.signAsync(user),
      refreshToken: await this.jwt.signAsync(user, {
        secret: process.env.JWT_REFRESH_TOKEN_SECRET_KEY,
        expiresIn: process.env.JWT_REFRESH_TOKEN_LIFE_SPAN,
      }),
    };
  }

  @Mutation(() => Token)
  async register(
    @Args('data', { type: () => RegisterParam }) userData: RegisterParam,
  ): Promise<Token> {
    const { password, ...data } = userData;
    const user = await this.user.createUser(data);
    await this.cred.generatePassword(user.id, password);
    return {
      token: await this.jwt.signAsync(user),
      refreshToken: await this.jwt.signAsync(user, {
        secret: process.env.JWT_REFRESH_TOKEN_SECRET_KEY,
        expiresIn: process.env.JWT_REFRESH_TOKEN_LIFE_SPAN,
      }),
    };
  }

  @Mutation(() => Token)
  async refresh(
    @Args('data', { type: () => String }) refreshToken: string,
  ): Promise<Token> {
    const user: UserDTO = await this.jwt.verifyAsync(refreshToken, {
      secret: process.env.JWT_REFRESH_TOKEN_SECRET_KEY,
    });
    return {
      token: await this.jwt.signAsync(user),
      refreshToken: await this.jwt.signAsync(user, {
        secret: process.env.JWT_REFRESH_TOKEN_SECRET_KEY,
        expiresIn: process.env.JWT_REFRESH_TOKEN_LIFE_SPAN,
      }),
    };
  }
}
