import { Field, InputType } from '@nestjs/graphql';

@InputType('UserData')
export class UserDataDTO {
  @Field()
  username: string;

  @Field()
  email: string;

  @Field()
  phone: string;
}
