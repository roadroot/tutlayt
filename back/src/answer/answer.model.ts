import { Field, ObjectType } from '@nestjs/graphql';
import { HasFilesGraphqlModel } from 'src/pagination/graphql_model';
import { UserDTO } from 'src/user/model/user.model';

@ObjectType('Answer')
export class AnswerDTO extends HasFilesGraphqlModel {
  @Field(() => UserDTO, { nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  @Field({ nullable: true })
  title?: string;

  @Field()
  body: string;

  @Field(() => [String])
  files: string[];
}
