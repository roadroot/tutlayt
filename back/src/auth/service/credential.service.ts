import { Injectable } from '@nestjs/common';
import { Credential } from '@prisma/client';
import { compare, hash } from 'bcrypt';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class CredentialService {
  constructor(private readonly prisma: PrismaService) {}

  private async _getLatestCredential(userId: string): Promise<Credential> {
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

  async verifyPassword(userId: string, password: string): Promise<boolean> {
    return await compare(
      password,
      (
        await this._getLatestCredential(userId)
      ).password,
    );
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
