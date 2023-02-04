import { Field, InputType } from '@nestjs/graphql';
import { FileUpload, GraphQLUpload } from 'graphql-upload-ts';

@InputType('UserUpdateData')
export class UpdateUserParam {
  @Field()
  id: string;

  @Field({ nullable: true })
  username?: string;

  @Field(() => GraphQLUpload, { nullable: true })
  image?: Promise<FileUpload>;
}
