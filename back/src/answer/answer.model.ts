import { UserDTO } from 'src/user/model/user.model';
import { Field, Int, ObjectType } from '@nestjs/graphql';
import { StorageService } from 'src/storage/storage.service';
import { File } from '@prisma/client';

@ObjectType('Answer')
export class AnswerDTO {
  @Field()
  id: string;

  @Field({ nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  creationDate: Date;

  @Field({nullable: true})
  title?: string;

  @Field()
  body: string;

  @Field(() => [String])
  files: String[];

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
  }): AnswerDTO {
    return {
      id,
      user,
      updateDate,
      creationDate,
      body,
      userId,
      title,
      files: 
        files?.map((file) => StorageService.getUrl(file))
    };
  }
}
