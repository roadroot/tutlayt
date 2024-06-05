import { Field, ObjectType } from "@nestjs/graphql";
import { File } from "@prisma/client";
import { getUrl } from "src/storage/storage.util";

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
      files: files?.map((file) => getUrl(file)),
    };
  }
}
