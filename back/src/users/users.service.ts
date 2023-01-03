import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}
  async getUser(
    id: {
      id?: number;
      username?: string;
      email?: string;
    },
    include = {
      creds: false,
      questions: false,
    },
  ) {
    return await this.prisma.user.findFirst({
      include,
      where: {
        id: id.id,
        username: id.username,
        email: id.email,
      },
    });
  }
}
