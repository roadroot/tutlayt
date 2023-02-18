import { Field, ObjectType } from '@nestjs/graphql';
import { HasFilesGraphqlModel } from 'src/pagination/graphql_model';
import { UserDTO } from 'src/user/model/user.model';

@ObjectType('Comment')
export class CommentDTO extends HasFilesGraphqlModel {
  @Field({ nullable: true })
  user?: UserDTO;

  userId: string;

  updateDate: Date;

  @Field()
  body: string;
}
