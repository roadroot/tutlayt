import { Field, InputType } from '@nestjs/graphql';

@InputType('AnswerData')
export class AnswerDataDTO {
  @Field({nullable: true})
  title?: string;

  @Field()
  body: string;

  @Field()
  questionId: string;
}
