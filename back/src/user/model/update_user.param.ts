import { Field, InputType } from '@nestjs/graphql';
import { GraphQLUpload } from 'graphql-upload-ts/dist/GraphQLUpload';
import { FileUpload } from 'src/storage/model/file_upload';

@InputType('UserUpdateData')
export class UpdateUserParam {
  @Field()
  id: string;

  @Field({ nullable: true })
  username?: string;

  @Field(() => GraphQLUpload, { nullable: true })
  image?: Promise<FileUpload>;
}
