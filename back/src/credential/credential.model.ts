import { Field, ID, ObjectType } from '@nestjs/graphql';

@ObjectType()
export default class Credential {
  @Field(() => ID)
  public readonly id: number;
  public readonly hash: string;

  constructor(id: number, hash: string) {
    this.id = id;
    this.hash = hash;
  }
}
