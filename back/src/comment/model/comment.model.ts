import { StorageService } from './../../storage/storage.service';
import { UserDTO } from 'src/user/model/user.model';
import { Field, ObjectType } from '@nestjs/graphql';
import { File } from '@prisma/client';

@ObjectType('Comment')
export class CommentDTO {
  @Field()
  id: string;

  @Field({ nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  creationDate: Date;

  @Field()
  body: string;

  @Field(() => [String], { nullable: true })
  files?: string[];

  static from({
    id,
    user,
    updateDate,
    creationDate,
    body,
    userId,
    files,
  }: {
    id: string;
    userId: string;
    user?: UserDTO;
    updateDate: Date;
    creationDate: Date;
    body: string;
    files: File[];
  }): CommentDTO {
    return {
      id,
      user,
      updateDate,
      creationDate,
      body,
      userId,
      files: files
        ? files.map((file) => StorageService.getUrl(file))
        : undefined,
    };
  }
}
