import { UserDataDTO } from './user-data.model';
import { QuestionService } from './../question/question.service';
import { UserDTO } from 'src/user/user.model';
import { UserService } from './../user/user.service';
import { QuestionDTO } from 'src/question/question.model';
import {
  Query,
  Resolver,
  Int,
  Args,
  ResolveField,
  Mutation,
} from '@nestjs/graphql';

@Resolver(() => UserDTO)
export default class UserResolver {
  constructor(
    private readonly questions: QuestionService,
    private readonly user: UserService,
  ) {}

  @Query(() => UserDTO, { name: 'user' })
  async getUser(@Args('id', { type: () => Int }) id: number): Promise<UserDTO> {
    return await this.user.getUser({ id });
  }

  @ResolveField(() => [QuestionDTO], { name: 'questions' })
  async getQuestions(parent: UserDTO): Promise<QuestionDTO[]> {
    return (
      parent.questions ?? (await this.questions.getQuestionsForUser(parent.id))
    );
  }

  @Mutation(() => UserDTO)
  async createUser(
    @Args('data', { type: () => UserDataDTO }) data: UserDataDTO,
  ): Promise<UserDTO> {
    return await this.user.createUser(data);
  }
}
