import { QuestionDataDTO } from './question_data.model';
import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';
import { QuestionDTO } from './question.model';

@Injectable()
export class QuestionService {
  constructor(private readonly prisma: PrismaService) {}

  async getQuestion(
    where: { id: number },
    include = { user: false },
  ): Promise<QuestionDTO> {
    return await this.prisma.question.findUnique({
      where,
      include,
    });
  }

  async getQuestionsForUser(userId: number): Promise<QuestionDTO[]> {
    return await this.prisma.question.findMany({
      where: {
        userId,
      },
    });
  }

  async createQuestion(
    data: QuestionDataDTO & { userId: number },
  ): Promise<QuestionDTO> {
    return await this.prisma.question.create({
      data,
    });
  }
}
