import { Field, InputType } from '@nestjs/graphql';

@InputType()
export class LoginParam {
  @Field()
  username: string;

  @Field()
  password: string;
}
