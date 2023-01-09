import { UseGuards } from '@nestjs/common';
import { QuestionService } from './../question/question.service';
import { UserDTO } from 'src/user/user.model';
import { UserService } from './../user/user.service';
import { QuestionDTO } from 'src/question/question.model';
import { Query, Resolver, Int, Args, ResolveField } from '@nestjs/graphql';
import { LocalAuthGuard } from 'src/auth/strategy/local/local.guard';

@Resolver(() => UserDTO)
export class UserResolver {
  constructor(
    private readonly questions: QuestionService,
    private readonly user: UserService,
  ) {}

  @UseGuards(LocalAuthGuard)
  @Query(() => UserDTO, { name: 'user' })
  async getUser(@Args('id', { type: () => Int }) id: number): Promise<UserDTO> {
    return await this.user.getUser({ id });
  }

  @UseGuards(LocalAuthGuard)
  @ResolveField(() => [QuestionDTO], { name: 'questions' })
  async getQuestions(parent: UserDTO): Promise<QuestionDTO[]> {
    return (
      parent.questions ?? (await this.questions.getQuestionsForUser(parent.id))
    );
  }
}
