import { Field, InputType } from '@nestjs/graphql';
import { FileUpload, GraphQLUpload } from 'graphql-upload-ts';

@InputType('CommentData')
export class CommentDataDTO {
  @Field()
  body: string;

  @Field(() => [GraphQLUpload], { nullable: true })
  files?: Promise<FileUpload>[];

  @Field({
    description:
      'The question that you want to comment. ' +
      'Required if answerId is not provided. ' +
      'Forbidden if answerId is provided. ',
    nullable: true,
  })
  questionId?: string;

  @Field({
    description:
      'The answer that you want to comment. ' +
      'Required if questionId is not provided. ' +
      'Forbidden if questionId is provided. ',
    nullable: true,
  })
  answerId?: string;
}
