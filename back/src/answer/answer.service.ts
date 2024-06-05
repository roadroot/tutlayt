import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { Base64 } from "src/pagination/pagination";
import { StorageService } from "src/storage/storage.service";
import { PrismaService } from "./../prisma/prisma.service";
import { AnswerDTO } from "./answer.model";
import { AnswerDataDTO } from "./answer_data.model";
import { ANSWER_ADDED } from "src/subscription/pubsub.cost";
import { SubService } from "src/subscription/sub.service";
import { markdown } from "src/storage/storage.util";

@Injectable()
export class AnswerService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    private readonly subService: SubService
  ) {}

  async getAnswer(
    where: { id: string },
    include = { user: false }
  ): Promise<AnswerDTO> {
    return AnswerDTO.from(
      await this.prisma.answer.findUnique({
        where,
        include: { files: true, ...include },
      })
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
    answerData: AnswerDataDTO & { userId: string }
  ): Promise<AnswerDTO> {
    const { files, ...data } = answerData;
    let answer = await this.prisma.answer.create({
      data,
      include: {
        files: true,
      },
    });

    const fs = await this.storage.saveFiles(
      process.env.ANSWER_STORAGE_PATH,
      answer.id,
      files
    );

    if (!!files) {
      answer = await this.prisma.answer.update({
        where: { id: answer.id },
        data: {
          files: {
            connect: fs.map((file) => ({ id: file.id })),
          },
          body: markdown(answer.body, fs),
        },
        include: {
          files: true,
        },
      });
    }

    const answerDTO = AnswerDTO.from(answer);
    await this.publishAnswerAdded(answerDTO);
    return answerDTO;
  }

  async getAnswers({
    take = 20,
    cursor,
    include = { user: false },
    questionId,
    userId,
  }: {
    take?: number;
    cursor?: string;
    userId?: string;
    questionId?: string;
    include?: { user: boolean };
  }): Promise<AnswerDTO[]> {
    return (
      await this.prisma.answer.findMany({
        take: take + 1,
        include: { ...include, files: true },
        where: {
          questionId,
          userId,
        },
        cursor: !!cursor
          ? {
              id: Base64.decode(cursor),
            }
          : undefined,
      })
    ).map((answer) => AnswerDTO.from(answer));
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
      })
    );
  }

  async publishAnswerAdded(answer: AnswerDTO) {
    await this.subService.publish(ANSWER_ADDED, answer);
  }
}
