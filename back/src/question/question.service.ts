import { QuestionDataDTO } from './question_data.model';
import { PrismaService } from './../prisma/prisma.service';
import { Injectable } from '@nestjs/common';
import { QuestionDTO } from './question.model';
import { StorageService } from 'src/storage/storage.service';

@Injectable()
export class QuestionService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
  ) {}

  async getQuestion(
    where: { id: string },
    include = { user: false },
  ): Promise<QuestionDTO> {
    return await this.prisma.question.findUnique({
      where,
      include,
    });
  }

  async getQuestionsForUser(userId: string): Promise<QuestionDTO[]> {
    return await this.prisma.question.findMany({
      where: {
        userId,
      },
    });
  }

  async createQuestion(
    questionData: QuestionDataDTO & { userId: string },
  ): Promise<QuestionDTO> {
    const { files, ...data } = questionData;
    const question = await this.prisma.question.create({
      data,
    });
    const fs = await this.storage.saveFiles(
      process.env.QUESTION_STORAGE_PATH,
      question.id,
      files,
    );
    return await this.prisma.question.update({
      where: { id: question.id },
      data: {
        files: {
          connect: fs.map((f) => ({ id: f.id })),
        },
      },
    });
  }
}
