import { Logger, UseGuards } from "@nestjs/common";
import {
  Args,
  Int,
  Mutation,
  Query,
  ResolveField,
  Resolver,
  Subscription,
} from "@nestjs/graphql";
import { AnswerDTO, AnswerPage } from "src/answer/answer.model";
import { JwtAuthGuard } from "src/auth/strategy/jwt/jwt.guard";
import { CurrentUser } from "src/auth/util/current_user.util";
import { UserDTO } from "src/user/model/user.model";
import { UserService } from "./../user/user.service";
import { AnswerService } from "./answer.service";
import { AnswerDataDTO } from "./answer_data.model";
import { ANSWER_ADDED } from "src/subscription/pubsub.cost";
import { SubService } from "src/subscription/sub.service";

@Resolver(() => AnswerDTO)
export default class AnswerResolver {
  logger: Logger = new Logger(AnswerResolver.name);

  constructor(
    private readonly answer: AnswerService,
    private readonly user: UserService,
    private readonly subService: SubService
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => AnswerDTO, { name: "answer" })
  async getAnswer(@Args("id") id: string) {
    return await this.answer.getAnswer({ id });
  }

  @UseGuards(JwtAuthGuard)
  @ResolveField("user", () => UserDTO)
  async resolveUser(parent: AnswerDTO): Promise<UserDTO> {
    return parent.user ?? (await this.user.getUser({ id: parent.userId }));
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => AnswerDTO)
  async createAnswer(
    // TODO add current user
    @Args("data") data: AnswerDataDTO,
    @CurrentUser() user: UserDTO
  ): Promise<AnswerDTO> {
    return await this.answer.createAnswer({ ...data, userId: user.id });
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => AnswerDTO)
  async delete(
    @Args("answerId") id: string,
    @CurrentUser() user: UserDTO
  ): Promise<AnswerDTO> {
    return await this.answer.delete(id, user.id);
  }

  @Query(() => AnswerPage, { name: "answers" })
  async getAnswers(
    @Args("take", { type: () => Int, nullable: true }) take = 20,
    @Args("cursor", { type: () => String, nullable: true }) cursor?: string,
    @Args("questionId", { type: () => String, nullable: true })
    questionId?: string,
    @Args("userId", { type: () => String, nullable: true }) userId?: string
  ): Promise<AnswerPage> {
    return new AnswerPage(
      await this.answer.getAnswers({ take, cursor, questionId, userId }),
      take
    );
  }

  @Subscription(() => AnswerDTO, {
    name: ANSWER_ADDED,
    nullable: true,
  })
  async answerAdded(
    @Args("questionId") _: string
  ): Promise<AsyncIterator<AnswerDTO>> {
    this.logger.log("Subscription");
    this.logger.log(_);
    return this.subService.pubSub.asyncIterator(ANSWER_ADDED);
  }
}
