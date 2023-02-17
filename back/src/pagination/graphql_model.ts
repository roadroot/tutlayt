import { Field, ObjectType } from '@nestjs/graphql';
import { File } from '@prisma/client';
import { StorageService } from 'src/storage/storage.service';

@ObjectType({ isAbstract: true })
export class GraphqlModel {
  @Field()
  id: string;

  creationDate: Date;
}

@ObjectType({ isAbstract: true })
export class HasFilesGraphqlModel extends GraphqlModel {
  @Field(() => [String])
  files?: string[];

  static from<T extends GraphqlModel>({
    files,
    ...args
  }: T & { files: File[] }) {
    return {
      ...args,
      files: files?.map((file) => StorageService.getUrl(file)),
    };
  }
}
