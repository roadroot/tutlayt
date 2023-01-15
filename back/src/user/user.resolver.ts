import { QuestionService } from './../question/question.service';
import { UserDTO } from 'src/user/model/user.model';
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
import { UpdateUserParam } from './model/update_user.param';
import { StorageService } from 'src/storage/storage.service';

@Resolver(() => UserDTO)
export class UserResolver {
  constructor(
    private readonly questions: QuestionService,
    private readonly user: UserService,
    private readonly storege: StorageService,
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
  async updateUser(
    @Args('data', { type: () => UpdateUserParam }) userData: UpdateUserParam,
  ): Promise<UserDTO> {
    const { image, ...data } = userData;
    const pictureId = (await this.storege.saveProfilePicture(data.id, image))
      .id;
    return await this.user.update(data.id, {
      pictureId,
      ...data,
    });
  }
}
