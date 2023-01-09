import { Field, InputType } from '@nestjs/graphql';

@InputType('QuestionData')
export class QuestionDataDTO {
  @Field()
  title: string;

  @Field()
  body: string;
}
