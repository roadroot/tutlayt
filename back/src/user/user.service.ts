import { Injectable } from '@nestjs/common';
import { UserDTO } from 'src/user/model/user.model';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async getUser(
    where: {
      id?: string;
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
      include: {
        pictures: true,
      },
    });
    return UserDTO.from(user);
  }

  async update(
    userId: string,
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
