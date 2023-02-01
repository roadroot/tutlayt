import { AnswerDataDTO } from './answer_data.model';
import { UserDTO } from 'src/user/model/user.model';
import { UserService } from './../user/user.service';
import { AnswerService } from './answer.service';
import { AnswerDTO } from 'src/answer/answer.model';
import { Query, Resolver, Args, ResolveField, Mutation } from '@nestjs/graphql';
import { UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/strategy/jwt/jwt.guard';
import { CurrentUser } from 'src/auth/util/current_user.util';

@Resolver(() => AnswerDTO)
export default class AnswerResolver {
  constructor(
    private readonly answer: AnswerService,
    private readonly user: UserService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => AnswerDTO, { name: 'answer' })
  async getAnswer(@Args('id') id: string) {
    return await this.answer.getAnswer({ id });
  }

  @UseGuards(JwtAuthGuard)
  @ResolveField('user', () => UserDTO)
  async resolveUser(parent: AnswerDTO): Promise<UserDTO> {
    return (
      parent.user ??
      (await this.user.getUser({
        id: parent.userId,
      }))
    );
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => AnswerDTO)
  async createAnswer(
    // TODO add current user
    @Args('data') data: AnswerDataDTO,
    @CurrentUser() user: UserDTO,
  ): Promise<AnswerDTO> {
    return await this.answer.createAnswer({ ...data, userId: user.id });
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => AnswerDTO)
  async delete(
    // TODO add current user
    @Args('answerId') id: string,
    @CurrentUser() user: UserDTO,
  ): Promise<AnswerDTO> {
    return await this.answer.delete(id, user.id);
  }
}
