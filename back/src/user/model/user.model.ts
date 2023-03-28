import { Field, ObjectType } from '@nestjs/graphql';
import { File, User } from '@prisma/client';
import { AnswerDTO } from 'src/answer/answer.model';
import { CommentDTO } from 'src/comment/model/comment.model';
import { GraphqlModel } from 'src/pagination/graphql_model';
import { QuestionDTO } from 'src/question/question.model';
import { StorageService } from 'src/storage/storage.service';

@ObjectType('User')
export class UserDTO extends GraphqlModel {
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

  @Field(() => [AnswerDTO], { nullable: true })
  answers?: AnswerDTO[];

  @Field(() => [CommentDTO], { nullable: true })
  comments?: AnswerDTO[];

  updateDate: Date;

  static from(user: User & { pictures: File[] }): UserDTO {
    return {
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      picture:
        user.pictures.length == 0
          ? `${process.env.SERVER_URL}/storage/${process.env.DEFAULT_PROFILE_PICTURE}` // TODO very bad idea
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
