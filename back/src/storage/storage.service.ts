import { Injectable } from '@nestjs/common';
import { join } from 'path';
import { createWriteStream, existsSync } from 'fs';
import { mkdir } from 'fs/promises';
import { File } from '@prisma/client';
import { PrismaService } from 'src/prisma/prisma.service';
import { FileUpload } from 'graphql-upload-ts';

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

  static getUrl(file: File): string {
    return `${process.env.SERVER_URL}/storage/${file.id}`;
  }

  async saveFiles(
    template: string,
    id: string,
    files?: Promise<FileUpload>[],
  ): Promise<File[]> {
    return await this.createFiles(
      template
        .replace('$id', id)
        .replace('$timestamp', new Date().getTime().toString()),
      files,
    );
  }

  async saveFile(
    template: string,
    id: string,
    file?: Promise<FileUpload>,
  ): Promise<File> {
    return await this.createFile(
      template
        .replace('$id', id)
        .replace('$timestamp', new Date().getTime().toString()),
      file,
    );
  }

  async mkdir(path: string): Promise<void> {
    if (!existsSync(path)) {
      await mkdir(path, { recursive: true });
    }
  }
}
