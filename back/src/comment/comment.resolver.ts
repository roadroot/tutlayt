import { UseGuards } from '@nestjs/common';
import { Args, Mutation, Query, ResolveField, Resolver } from '@nestjs/graphql';
import { CurrentUser } from 'src/auth/util/current_user.util';
import { JwtAuthGuard } from './../auth/strategy/jwt/jwt.guard';
import { UserDTO } from './../user/model/user.model';
import { UserService } from './../user/user.service';
import { CommentService } from './comment.service';
import { CommentDTO } from './model/comment.model';
import { CommentDataDTO } from './model/comment_data';

@Resolver(() => CommentDTO)
export class CommentResolver {
  constructor(
    private readonly comment: CommentService,
    private readonly user: UserService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Query(() => CommentDTO, { name: 'comment' })
  async getQuestion(@Args('id') id: string): Promise<CommentDTO> {
    return await this.comment.getComment({ id });
  }

  @UseGuards(JwtAuthGuard)
  @ResolveField('user', () => UserDTO)
  async getUser(parent: CommentDTO): Promise<UserDTO> {
    return (
      parent.user ??
      (await this.user.getUser({
        id: parent.userId,
      }))
    );
  }

  @UseGuards(JwtAuthGuard)
  @Mutation(() => CommentDTO)
  async createComment(
    @Args('data', { type: () => CommentDataDTO }) data: CommentDataDTO,
    @CurrentUser() user: UserDTO,
  ): Promise<CommentDTO> {
    return await this.comment.createComment({ userId: user.id, ...data });
  }
}
