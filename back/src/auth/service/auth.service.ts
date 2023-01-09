import { CredentialService } from './credential.service';
import { UserService } from '../../user/user.service';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Args, Mutation } from '@nestjs/graphql';
import { LoginParam } from '../model/login.param';
import { UserDTO } from 'src/user/user.model';
import { UserDataDTO } from 'src/user/user_data.model';

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

  @Mutation(() => String)
  async register(
    @Args('data', { type: () => UserDataDTO }) userData: UserDataDTO,
  ): Promise<string> {
    const { password, ...data } = userData;
    const user = await this.user.createUser(data);
    await this.cred.generatePassword(user.id, password);
    return await this.jwt.signAsync(user);
  }
}
