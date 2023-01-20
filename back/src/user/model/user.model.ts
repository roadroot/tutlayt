import { QuestionDTO } from 'src/question/question.model';
import { Field, ObjectType } from '@nestjs/graphql';
import { File, User } from '@prisma/client';
import { StorageService } from 'src/storage/storage.service';

@ObjectType('User')
export class UserDTO {
  @Field()
  id: string;

  @Field()
  username: string;

  @Field()
  email: string;

  @Field({ nullable: true })
  phone?: string;

  @Field({ nullable: true })
  picture?: string;

  @Field(() => [QuestionDTO], { nullable: true })
  questions?: QuestionDTO[];

  updateDate: Date;

  creationDate: Date;

  static from(user: User & { pictures: File[] }): UserDTO {
    return {
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      picture:
        user.pictures.length == 0
          ? `${process.env.SERVER_URL}/storage/tazerzit.png` // TODO very bad idea
          : StorageService.getUrl(
              user.pictures.reduce((a, b) =>
                a.creationDate.getTime() > b.creationDate.getTime() ? a : b,
              ),
            ),
      updateDate: user.updateDate,
      creationDate: user.creationDate,
    };
  }
}