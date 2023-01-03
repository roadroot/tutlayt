import { UserService } from '../user/user.service';
import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';
import { Credential } from '@prisma/client';

@Injectable()
export class CredentialService {
  constructor(
    private readonly users: UserService,
    private readonly prisma: PrismaService,
  ) {}

  async getLatestCredential(userId: number): Promise<Credential> {
    return await this.prisma.credential.findFirst({
      where: {
        userId,
        creationDate: (
          await this.prisma.credential.aggregate({
            _max: {
              creationDate: true,
            },
          })
        )._max.creationDate,
      },
    });
  }
}
