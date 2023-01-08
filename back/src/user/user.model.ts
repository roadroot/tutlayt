import { QuestionDTO } from 'src/question/question.model';
import { Field, Int, ObjectType } from '@nestjs/graphql';

@ObjectType('User')
export class UserDTO {
  @Field(() => Int)
  id: number;

  @Field()
  username: string;

  @Field()
  email: string;

  @Field()
  phone: string;

  @Field({ nullable: true })
  picture?: string;

  @Field(() => [QuestionDTO], { nullable: true })
  questions?: QuestionDTO[];

  updateDate: Date;

  creationDate: Date;
}
