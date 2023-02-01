import { CurrentUser } from 'src/auth/util/current_user.util';
import { QuestionDataDTO } from './../question/question_data.model';
import { UserDTO } from './../user/model/user.model';
import { QuestionDTO } from './../question/question.model';
import { JwtAuthGuard } from './../auth/strategy/jwt/jwt.guard';
import { UseGuards } from '@nestjs/common';
import { UserService } from './../user/user.service';
import { QuestionService } from './../question/question.service';
import { Resolver, Query, Args, ResolveField, Mutation } from '@nestjs/graphql';

@Resolver()
export class CommentResolver {
  constructor(
    private readonly question: QuestionService,
    private readonly user: UserService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => QuestionDTO, { name: 'question' })
  async getQuestion(@Args('id') id: string) {
    return await this.question.getQuestion({ id });
  }

  @UseGuards(JwtAuthGuard)
  @ResolveField('user', () => UserDTO)
  async getUser(parent: QuestionDTO): Promise<UserDTO> {
    return (
      parent.user ??
      (await this.user.getUser({
        id: parent.id,
      }))
    );
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => QuestionDTO)
  async createQuestion(
    @Args('data', { type: () => QuestionDataDTO }) data: QuestionDataDTO,
    @CurrentUser() user: UserDTO,
  ): Promise<QuestionDTO> {
    return await this.question.createQuestion({ userId: user.id, ...data });
  }
}
