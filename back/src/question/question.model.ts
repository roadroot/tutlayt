import { UserDTO } from 'src/user/user.model';
import { Field, Int, ObjectType } from '@nestjs/graphql';

@ObjectType('Question')
export class QuestionDTO {
  @Field(() => Int)
  id: number;

  @Field(() => UserDTO, { nullable: true })
  user?: UserDTO;

  userId: number;

  updateDate: Date;

  creationDate: Date;

  @Field()
  title: string;

  @Field()
  body: string;
}
