import { Field, ObjectType } from '@nestjs/graphql';

@ObjectType()
export class Token {
  @Field()
  token: string;

  @Field()
  refreshToken: string;
}
