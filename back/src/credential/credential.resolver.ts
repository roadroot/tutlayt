import {
  Args,
  Int,
  Parent,
  Query,
  ResolveField,
  Resolver,
} from '@nestjs/graphql';
import Credential from './credential.model';

@Resolver(() => Credential)
export default class CredentialResolver {
  @Query(() => Credential)
  async author(
    @Args('id', { type: () => Int }) id: number,
  ): Promise<Credential> {
    return new Credential(id, id + 'hdkjfhldskjfhlskdjfh');
  }

  @ResolveField()
  posts(@Parent() author: Credential): Credential {
    return author;
  }
}
