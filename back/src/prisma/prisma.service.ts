import { Injectable, OnModuleInit, INestApplication } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  async onModuleInit() {
    await this.$connect();
    await this.createUsers();
  }

  async enableShutdownHooks(app: INestApplication) {
    this.$on('beforeExit', async () => {
      await app.close();
    });
  }

  async createUsers(count = 5) {
    const users = [];
    for (let i = 0; i < count; i++) {
      users.push({
        email: `email_${i}`,
        phone: `phone_${i}`,
        username: `userrname_${i}`,
      });
    }
    await this.user.createMany({
      data: users,
      skipDuplicates: true,
    });
    for (let i = 0; i < count; i++) {
      const user = await this.user.findFirst({
        select: {
          id: true,
        },
        where: {
          username: `userrname_${i}`,
        },
      });
      await this.credential.createMany({
        skipDuplicates: true,
        data: {
          userId: user.id,
          password: `password_${i}`,
        },
      });
    }
  }
}
