import { Field, InputType } from '@nestjs/graphql';

@InputType('UserData')
export class UserDataDTO {
  @Field()
  username: string;

  @Field()
  email: string;

  @Field()
  password: string;

  @Field({ nullable: true })
  phone?: string;
}
