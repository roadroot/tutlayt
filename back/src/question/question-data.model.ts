import { Field, InputType, Int } from '@nestjs/graphql';

@InputType('QuestionData')
export class QuestionDataDTO {
  @Field()
  title: string;

  @Field()
  body: string;

  @Field(() => Int)
  userId: number;
}
