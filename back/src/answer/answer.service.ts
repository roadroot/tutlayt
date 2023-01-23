import { AnswerDataDTO } from './answer_data.model';
import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';
import { AnswerDTO } from './answer.model';

@Injectable()
export class AnswerService {
  constructor(private readonly prisma: PrismaService) {}

  async getAnswer(
    where: { id: string },
    include = { user: false },
  ): Promise<AnswerDTO> {
    return await this.prisma.answer.findUnique({
      where,
      include,
    });
  }

  async getAnswersForUser(userId: string): Promise<AnswerDTO[]> {
    return await this.prisma.answer.findMany({
      where: {
        userId,
      },
    });
  }

  async createAnswer(
    data: AnswerDataDTO & { userId: string, questionId: string },
  ): Promise<AnswerDTO> {
    return await this.prisma.answer.create({
      data
    });
  }
}
