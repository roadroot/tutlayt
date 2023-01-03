import { QuestionDataDTO } from './question-data.model';
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

@Resolver(() => QuestionDTO)
export default class QuestionResolver {
  constructor(
    private readonly question: QuestionService,
    private readonly user: UserService,
  ) {}

  @Query(() => QuestionDTO, { name: 'question' })
  async getQuestion(@Args('id', { type: () => Int }) id: number) {
    return await this.question.getQuestion({ id });
  }

  @ResolveField('user', () => UserDTO)
  async getUser(parent: QuestionDTO): Promise<UserDTO> {
    return (
      parent.user ??
      (await this.user.getUser({
        id: parent.id,
      }))
    );
  }

  @Mutation(() => QuestionDTO)
  async createQuestion(
    @Args('data', { type: () => QuestionDataDTO }) data: QuestionDataDTO,
  ): Promise<QuestionDTO> {
    return await this.question.createQuestion(data);
  }
}
