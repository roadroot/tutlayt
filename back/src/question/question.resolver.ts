import { QuestionDataDTO } from './question_data.model';
import { UserDTO } from 'src/user/user.model';
import { UserService } from './../user/user.service';
import { QuestionService } from './question.service';
import { QuestionDTO } from 'src/question/question.model';
import {
  Query,
  Resolver,
  Int,
  Args,
  ResolveField,
  Mutation,
} from '@nestjs/graphql';
import { UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/strategy/jwt/jwt.guard';
import { CurrentUser } from 'src/auth/util/current_user.util';

@Resolver(() => QuestionDTO)
export default class QuestionResolver {
  constructor(
    private readonly question: QuestionService,
    private readonly user: UserService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => QuestionDTO, { name: 'question' })
  async getQuestion(@Args('id', { type: () => Int }) id: number) {
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
