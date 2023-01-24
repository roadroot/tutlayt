import { Injectable } from '@nestjs/common';
import { FileUpload } from './model/file_upload';
import { join } from 'path';
import { createWriteStream, existsSync } from 'fs';
import { mkdir } from 'fs/promises';
import { File } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class StorageService {
  constructor(private readonly prisma: PrismaService) {}

  async createFile(
    filePath: string,
    file?: Promise<FileUpload>,
  ): Promise<File> | undefined {
    await this.mkdir(filePath);
    if (!file) {
      return undefined;
    }
    const fu = await file;
    const path = join(filePath, fu.filename);
    fu.createReadStream().pipe(createWriteStream(path));
    return await this.prisma.file.create({
      data: {
        path,
      },
    });
  }

  async getFile(id: string): Promise<File | undefined> {
    return await this.prisma.file.findUnique({
      where: {
        id,
      },
    });
  }

  async createFiles(
    path: string,
    files?: Promise<FileUpload>[],
  ): Promise<File[]> | undefined {
    if (!files) {
      return undefined;
    }
    return Promise.all(
      files.map(async (file) => await this.createFile(path, file)),
    );
  }

  async saveProfilePicture(
    userId: string,
    file?: Promise<FileUpload>,
  ): Promise<File> | undefined {
    return await this.createFile(
      process.env.PROFILE_STORAGE_PATH.replace(
        '$userId',
        userId.toString(),
      ).replace('$timestamp', new Date().getTime().toString()),
      file,
    );
  }

  static getUrl(file: File): string {
    return `${process.env.SERVER_URL}/storage/${file.id}`;
  }

  async saveQuestionPictures(
    questionId: string,
    files?: Promise<FileUpload>[],
  ): Promise<File[]> | undefined {
    return await this.createFiles(
      process.env.QUESTION_STORAGE_PATH.replace(
        '$questionId',
        questionId.toString(),
      ).replace('$timestamp', new Date().getTime().toString()),
      files,
    );
  }

  async saveAnswerFiles(
    answerId: string,
    files?: Promise<FileUpload>[],
  ): Promise<File[]> | undefined {
    return await this.createFiles(
      process.env.ANSWER_STORAGE_PATH.replace(
        '$answerId',
        answerId.toString(),
      ).replace('$timestamp', new Date().getTime().toString()),
      files,
    );
  }

  async saveCommentPictures(
    commentId: string,
    files?: Promise<FileUpload>[],
  ): Promise<File[]> | undefined {
    return await this.createFiles(
      process.env.QUESTION_STORAGE_PATH.replace(
        '$commentId',
        commentId.toString(),
      ).replace('$timestamp', new Date().getTime().toString()),
      files,
    );
  }

  async mkdir(path: string): Promise<void> {
    if (!existsSync(path)) {
      await mkdir(path, { recursive: true });
    }
  }
}
