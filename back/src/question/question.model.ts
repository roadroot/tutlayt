import { UserDTO } from 'src/user/model/user.model';
import { Field, ObjectType } from '@nestjs/graphql';
import { StorageService } from 'src/storage/storage.service';
import { File } from '@prisma/client';

@ObjectType('Question')
export class QuestionDTO {
  @Field()
  id: string;

  @Field(() => UserDTO, { nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  creationDate: Date;

  @Field()
  title: string;

  @Field()
  body: string;

  @Field(() => [String])
  files: string[];

  static from({
    id,
    user,
    userId,
    updateDate,
    creationDate,
    title,
    body,
    files,
  }: {
    id: string;
    userId: string;
    user?: UserDTO;
    updateDate: Date;
    creationDate: Date;
    body: string;
    title?: string;
    files: File[];
  }): QuestionDTO {
    return {
      id,
      user,
      updateDate,
      creationDate,
      body,
      userId,
      title,
      files: files?.map((file) => StorageService.getUrl(file)),
    };
  }
}
