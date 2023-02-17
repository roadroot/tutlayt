import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { StorageService } from 'src/storage/storage.service';
import { PrismaService } from './../prisma/prisma.service';
import { CommentDTO } from './model/comment.model';
import { CommentDataDTO } from './model/comment_data';

@Injectable()
export class CommentService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
  ) {}

  async getComment(where: { id: string }): Promise<CommentDTO> {
    return await this.prisma.comment.findUnique({ where });
  }

  async createComment({
    files,
    ...data
  }: CommentDataDTO & { userId: string }): Promise<CommentDTO> {
    const comment = await this.prisma.comment.create({
      data,
    });
    const fs = await this.storage.saveFiles(
      process.env.COMMENT_STORAGE_PATH,
      comment.id,
      files,
    );
    return await this.prisma.comment.update({
      where: { id: comment.id },
      data: {
        files: {
          connect: fs.map((f) => ({ id: f.id })),
        },
      },
    });
  }

  async getCommentsForUser(userId: string): Promise<CommentDTO[]> {
    return this.prisma.comment.findMany({
      where: { userId },
    });
  }

  async delete(id: string, userId: string): Promise<CommentDTO> {
    const comment = await this.prisma.comment.findUnique({
      where: {
        id,
      },
      select: {
        userId: true,
      },
    });
    if (!!comment) {
      throw new NotFoundException();
    }
    if (comment.userId !== userId) {
      throw new ForbiddenException();
    }
    return CommentDTO.from(
      await this.prisma.comment.delete({
        where: {
          id: id,
        },
        include: {
          files: true,
        },
      }),
    );
  }
}
