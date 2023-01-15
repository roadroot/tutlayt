import { Controller, Get, Res } from '@nestjs/common';
import { Param } from '@nestjs/common/decorators';
import { Response } from 'express';
import { createReadStream } from 'fs';
import { StorageService } from './storage.service';

@Controller('/storage')
export class StorageController {
  constructor(private readonly storageService: StorageService) {}

  @Get('/:id')
  async getFile(@Res() res: Response, @Param('id') id: string) {
    // TODO very bad idea
    if (id === 'tazerzit.png') {
      createReadStream('tazerzit.png').pipe(res);
    } else {
      createReadStream((await this.storageService.getFile(id)).path).pipe(res);
    }
  }
}
