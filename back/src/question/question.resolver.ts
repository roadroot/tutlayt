import { UseGuards } from "@nestjs/common";
import {
  Args,
  Int,
  Mutation,
  Query,
  ResolveField,
  Resolver,
  Subscription,
} from "@nestjs/graphql";
import { JwtAuthGuard } from "src/auth/strategy/jwt/jwt.guard";
import { CurrentUser } from "src/auth/util/current_user.util";
import { QuestionDTO, QuestionPage } from "src/question/question.model";
import { UserDTO } from "src/user/model/user.model";
import { UserService } from "./../user/user.service";
import { QuestionService } from "./question.service";
import { QuestionDataDTO } from "./question_data.model";
import { CommentDTO } from "src/comment/model/comment.model";
import { SubService } from "src/subscription/sub.service";
import { COMMENT_ADDED } from "src/subscription/pubsub.cost";

@Resolver(() => QuestionDTO)
export default class QuestionResolver {
  constructor(
    private readonly question: QuestionService,
    private readonly user: UserService,
    private readonly subService: SubService
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => QuestionDTO, { name: "question" })
  async getQuestion(@Args("id") id: string) {
    return await this.question.getQuestion({ id });
  }

  @UseGuards(JwtAuthGuard)
  @ResolveField("user", () => UserDTO)
  async getUser(parent: QuestionDTO): Promise<UserDTO> {
    return (
      parent.user ??
      (await this.user.getUser({
        id: parent.userId,
      }))
    );
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => QuestionDTO)
  async createQuestion(
    @Args("data", { type: () => QuestionDataDTO }) data: QuestionDataDTO,
    @CurrentUser() user: UserDTO
  ): Promise<QuestionDTO> {
    return await this.question.createQuestion({ userId: user.id, ...data });
  }

  @Query(() => QuestionPage, { name: "questions" })
  async getQuestions(
    @Args("take", { type: () => Int, nullable: true }) take = 20,
    @Args("cursor", { type: () => String, nullable: true }) cursor?: string
  ): Promise<QuestionPage> {
    return new QuestionPage(
      await this.question.getQuestions({ take, cursor }),
      take
    );
  }

  @Subscription(() => CommentDTO, {
    name: COMMENT_ADDED,
    nullable: true,
    filter: (payload, variables) =>
      payload[COMMENT_ADDED].questionId === variables.questionId,
  })
  async commentAdded(
    @Args("questionId") _: string
  ): Promise<AsyncIterator<CommentDTO>> {
    return this.subService.pubSub.asyncIterator(COMMENT_ADDED);
  }
}
