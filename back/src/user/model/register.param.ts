import { Field, InputType } from '@nestjs/graphql';
import { FileUpload, GraphQLUpload } from 'graphql-upload-ts';

@InputType('RegisterData')
export class RegisterParam {
  @Field()
  username: string;

  @Field()
  email: string;

  @Field()
  password: string;

  @Field({ nullable: true })
  phone?: string;

  @Field(() => GraphQLUpload, { nullable: true })
  image?: Promise<FileUpload>;
}
