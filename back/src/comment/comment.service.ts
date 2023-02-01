import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';

@Injectable()
export class CommentService {
  constructor(private readonly prisma: PrismaService) {}

  getComment(where: { id: string }) {
    return this.prisma.comment.findUnique({ where });
  }

  getCommentsForUser(userId: string) {
    return this.prisma.comment.findMany({
      where: { userId },
    });
  }
}
