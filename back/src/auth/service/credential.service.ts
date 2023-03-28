import { Injectable } from '@nestjs/common';
import { Credential } from '@prisma/client';
import { compare, hash } from 'bcrypt';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class CredentialService {
  constructor(private readonly prisma: PrismaService) {}

  private async _getLatestCredential(
    userId: string,
    include: {
      user: boolean;
    } = {
      user: false,
    },
  ): Promise<Credential> {
    const cred = await this.prisma.credential.findFirst({
      where: {
        creationDate: (
          await this.prisma.credential.aggregate({
            where: {
              userId,
            },
            _max: {
              creationDate: true,
            },
          })
        )._max.creationDate,
        userId,
      },
      include,
    });
    return cred;
  }

  async verifyPassword(userId: string, password: string): Promise<boolean> {
    const t = await this._getLatestCredential(userId);
    return await compare(password, t.password);
  }

  async generatePassword(
    userId: string,
    password: string,
  ): Promise<Credential> {
    return await this.prisma.credential.create({
      data: {
        password: await hash(password, 12),
        userId,
      },
    });
  }
}
