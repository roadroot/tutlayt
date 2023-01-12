import { CredentialService } from './credential.service';
import { UserService } from '../../user/user.service';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Args, Mutation } from '@nestjs/graphql';
import { LoginParam } from '../model/login.param';
import { UserDTO } from 'src/user/user.model';
import { UserDataDTO } from 'src/user/user_data.model';
import { Token } from '../model/token.model';

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

  @Mutation(() => String)
  async login(
    @Args('data', { type: () => LoginParam }) credentials: LoginParam,
  ): Promise<string> {
    const user = await this.validateUser(
      credentials.username,
      credentials.password,
    );
    if (user === null) {
      throw new UnauthorizedException();
    }
    return await this.jwt.signAsync(user);
  }

  @Mutation(() => Token)
  async register(
    @Args('data', { type: () => UserDataDTO }) userData: UserDataDTO,
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
