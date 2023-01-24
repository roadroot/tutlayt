import { AnswerDataDTO } from './answer_data.model';
import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';
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
    const fileUrls = await this.storage.saveAnswerFiles(answer.id, files);

    const completeAnswer = await this.prisma.answer.update({
      data: {
        files: {
          connect: fileUrls,
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
}
