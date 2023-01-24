import { Field, InputType } from '@nestjs/graphql';
import { FileUpload, GraphQLUpload } from 'graphql-upload-ts';
@InputType('AnswerData')
export class AnswerDataDTO {
  @Field({nullable: true})
  title?: string;

  @Field()
  body: string;

  @Field()
  questionId: string;

  @Field(() => [GraphQLUpload])
  files: Promise<FileUpload>[];
}
