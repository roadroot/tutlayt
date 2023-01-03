import { User } from '@prisma/client';
import { CredentialService } from './../credential/credential.service';
import { UserService } from '../user/user.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  constructor(
    private readonly users: UserService,
    private readonly creds: CredentialService,
  ) {}

  async validateUser(username: string, password: string): Promise<User | null> {
    const user = await this.users.getUser({
      username,
    });
    return user &&
      (await this.creds.getLatestCredential(user.id))?.password === password
      ? user
      : null;
  }
}
