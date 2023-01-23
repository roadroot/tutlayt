import { UserDTO } from 'src/user/model/user.model';
import { Field, Int, ObjectType } from '@nestjs/graphql';

@ObjectType('Answer')
export class AnswerDTO {
  @Field()
  id: string;

  @Field({ nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  creationDate: Date;

  @Field({nullable: true})
  title?: string;

  @Field()
  body: string;
}
