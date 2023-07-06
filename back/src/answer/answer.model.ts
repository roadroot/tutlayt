import { Field, ObjectType } from '@nestjs/graphql';
import { HasFilesGraphqlModel } from 'src/pagination/graphql_model';
import { Paginated } from 'src/pagination/pagination';
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

@ObjectType()
export class AnswerPage extends Paginated(AnswerDTO, 'Answer') {}
