import { UserDTO } from 'src/user/model/user.model';
import { PrismaService } from '../prisma/prisma.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async getUser(
    where: {
      id?: number;
      username?: string;
      email?: string;
    },
    include = {
      creds: false,
      questions: false,
    },
  ): Promise<UserDTO> {
    return UserDTO.from(
      await this.prisma.user.findFirst({
        include: { pictures: true, ...include },
        where,
      }),
    );
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

  async update(
    userId: number,
    params: { username?: string; pictureId?: string },
  ): Promise<UserDTO> {
    return UserDTO.from(
      await this.prisma.user.update({
        where: {
          id: userId,
        },
        data: {
          username: params.username,
          pictures: {
            connect: {
              id: params.pictureId,
            },
          },
        },
        include: {
          pictures: true,
        },
      }),
    );
  }
}
