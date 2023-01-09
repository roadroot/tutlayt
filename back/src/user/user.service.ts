import { UserDTO } from 'src/user/user.model';
import { PrismaService } from '../prisma/prisma.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UserService {
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

  async createUser(data: {
    username: string;
    email: string;
    phone?: string;
  }): Promise<UserDTO> {
    const user = await this.prisma.user.create({
      data,
    });
    return user;
  }
}
