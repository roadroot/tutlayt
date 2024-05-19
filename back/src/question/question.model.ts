import { Field, ObjectType } from "@nestjs/graphql";
import { HasFilesGraphqlModel } from "src/pagination/graphql_model";
import { Paginated } from "src/pagination/pagination";
import { UserDTO } from "src/user/model/user.model";

@ObjectType("Question")
export class QuestionDTO extends HasFilesGraphqlModel {
  @Field(() => UserDTO, { nullable: true })
  user?: UserDTO;

  @Field()
  userId: string;

  @Field()
  creationDate: Date;

  @Field()
  updateDate: Date;

  @Field()
  title: string;

  @Field()
  body: string;

  @Field(() => [String])
  files: string[];
}

@ObjectType()
export class QuestionPage extends Paginated(QuestionDTO, "Question") {}
