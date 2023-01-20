import { UserDTO } from 'src/user/model/user.model';
import { Field, ObjectType } from '@nestjs/graphql';

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
}
