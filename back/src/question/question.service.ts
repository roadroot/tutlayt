import { Injectable } from "@nestjs/common";
import { Base64 } from "src/pagination/pagination";
import { StorageService } from "src/storage/storage.service";
import { PrismaService } from "./../prisma/prisma.service";
import { QuestionDTO } from "./question.model";
import { QuestionDataDTO } from "./question_data.model";

@Injectable()
export class QuestionService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService
  ) {}

  async getQuestion(
    where: { id: string },
    include = { user: false }
  ): Promise<QuestionDTO> {
    return QuestionDTO.from(
      await this.prisma.question.findUnique({
        where,
        include: {
          ...include,
          files: true,
        },
      })
    );
  }

  async getQuestionsForUser(userId: string): Promise<QuestionDTO[]> {
    return (
      await this.prisma.question.findMany({
        where: {
          userId,
        },
        include: {
          files: true,
        },
      })
    ).map((question) => QuestionDTO.from(question));
  }

  async createQuestion(
    questionData: QuestionDataDTO & { userId: string }
  ): Promise<QuestionDTO> {
    const { files, ...data } = questionData;
    let question = await this.prisma.question.create({
      data,
      include: {
        files: true,
      },
    });
    const fs = await this.storage.saveFiles(
      process.env.QUESTION_STORAGE_PATH,
      question.id,
      files
    );
    if (!!files) {
      question = await this.prisma.question.update({
        where: { id: question.id },
        data: {
          files: {
            connect: fs.map((f) => ({ id: f.id })),
          },
        },
        include: {
          files: true,
        },
      });
    }
    return QuestionDTO.from(question);
  }

  async getQuestions({
    take = 20,
    cursor,
    include = { user: false },
  }: {
    take?: number;
    cursor?: string;
    include?: { user: boolean };
  }): Promise<QuestionDTO[]> {
    return (
      await this.prisma.question.findMany({
        take: take + 1,
        include: { ...include, files: true },
        cursor: !!cursor
          ? {
              id: Base64.decode(cursor),
            }
          : undefined,
      })
    ).map((question) => QuestionDTO.from(question));
  }
}
