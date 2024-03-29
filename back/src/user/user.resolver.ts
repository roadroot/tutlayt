import { Args, Mutation, Query, ResolveField, Resolver } from '@nestjs/graphql';
import { AnswerDTO } from 'src/answer/answer.model';
import { AnswerService } from 'src/answer/answer.service';
import { QuestionDTO } from 'src/question/question.model';
import { StorageService } from 'src/storage/storage.service';
import { UserDTO } from 'src/user/model/user.model';
import { CommentService } from './../comment/comment.service';
import { CommentDTO } from './../comment/model/comment.model';
import { QuestionService } from './../question/question.service';
import { UserService } from './../user/user.service';
import { UpdateUserParam } from './model/update_user.param';

@Resolver(() => UserDTO)
export class UserResolver {
  constructor(
    private readonly answer: AnswerService,
    private readonly questions: QuestionService,
    private readonly user: UserService,
    private readonly storage: StorageService,
    private readonly comment: CommentService,
  ) {}

  @Query(() => UserDTO, { name: 'user' })
  async getUser(@Args('id') id: string): Promise<UserDTO> {
    return await this.user.getUser({ id });
  }

  @ResolveField(() => [QuestionDTO], { name: 'questions', nullable: true })
  async resolveQuestions(parent: UserDTO): Promise<QuestionDTO[]> {
    return (
      parent.questions ?? (await this.questions.getQuestionsForUser(parent.id))
    );
  }

  @ResolveField(() => [AnswerDTO], { name: 'answers', nullable: true })
  async resolveAnswers(parent: UserDTO): Promise<AnswerDTO[]> {
    return parent.answers ?? (await this.answer.getAnswersForUser(parent.id));
  }

  @ResolveField(() => [CommentDTO], { name: 'comments', nullable: true })
  async resolveComment(parent: UserDTO): Promise<CommentDTO[]> {
    return (
      parent.questions ?? (await this.comment.getCommentsForUser(parent.id))
    );
  }

  @Mutation(() => UserDTO)
  async updateUser(
    @Args('data', { type: () => UpdateUserParam }) userData: UpdateUserParam,
  ): Promise<UserDTO> {
    const { image, ...data } = userData;
    const pictureId = (
      await this.storage.saveFile(
        process.env.PROFILE_STORAGE_PATH,
        data.id,
        image,
      )
    ).id;
    return await this.user.update(data.id, {
      pictureId,
      ...data,
    });
  }
}
