import { AnswerDataDTO } from './answer_data.model';
import { PrismaService } from './../prisma/prisma.service';
import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { AnswerDTO } from './answer.model';
import { StorageService } from 'src/storage/storage.service';

@Injectable()
export class AnswerService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
  ) {}

  async getAnswer(
    where: { id: string },
    include = { user: false },
  ): Promise<AnswerDTO> {
    return AnswerDTO.from(
      await this.prisma.answer.findUnique({
        where,
        include: { files: true, ...include },
      }),
    );
  }

  async getAnswersForUser(userId: string): Promise<AnswerDTO[]> {
    return (
      await this.prisma.answer.findMany({
        where: {
          userId,
        },
        include: {
          files: true,
        },
      })
    ).map((answer) => AnswerDTO.from(answer));
  }

  async createAnswer(
    answerData: AnswerDataDTO & { userId: string },
  ): Promise<AnswerDTO> {
    const { files, ...data } = answerData;
    const answer = await this.prisma.answer.create({
      data,
      include: {
        files: true,
      },
    });
    const fileUrls = await this.storage.saveFiles(
      process.env.ANSWER_STORAGE_PATH,
      answer.id,
      files,
    );

    const completeAnswer = await this.prisma.answer.update({
      data: {
        files: {
          connect: fileUrls.map((file) => ({ id: file.id })),
        },
      },
      where: {
        id: answer.id,
      },
      include: {
        files: true,
      },
    });
    return AnswerDTO.from(completeAnswer);
  }

  async delete(id: string, userId: string): Promise<AnswerDTO> {
    const answer = await this.prisma.answer.findUnique({
      where: {
        id,
      },
      select: {
        userId: true,
      },
    });
    if (!!answer) {
      throw new NotFoundException();
    }
    if (answer.userId !== userId) {
      throw new ForbiddenException();
    }
    return AnswerDTO.from(
      await this.prisma.answer.delete({
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
