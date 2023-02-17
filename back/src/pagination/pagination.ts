import { Type } from '@nestjs/common';
import { Field, Int, ObjectType } from '@nestjs/graphql';
import { GraphqlModel } from './graphql_model';

export abstract class Base64 {
  static encode(str: string): string {
    return Buffer.from(str).toString('base64');
  }

  static decode(str: string): string {
    return Buffer.from(str, 'base64').toString('utf8');
  }
}

@ObjectType({ isAbstract: true })
export class EdgeType<T extends GraphqlModel> {
  @Field(() => String)
  get cursor(): string {
    return Base64.encode(this.node.id);
  }

  node: T;

  constructor(node: T) {
    this.node = node;
  }
}

@ObjectType({ isAbstract: true })
export class PageInfoType {
  @Field(() => String, { nullable: true })
  startCursor?: string;

  @Field(() => String, { nullable: true })
  endCursor?: string;

  @Field(() => Boolean)
  hasNextPage: boolean;

  @Field(() => Int)
  pageSize: number;

  @Field(() => Int)
  count: number;

  constructor(nodes: GraphqlModel[], pageSize: number) {
    this.hasNextPage = nodes.length > pageSize;
    this.pageSize = pageSize;
    this.count = nodes.length > pageSize ? nodes.length - 1 : nodes.length;

    if (nodes.length > 1) {
      this.startCursor = Base64.encode(nodes[0].id);
      this.endCursor = Base64.encode(
        nodes[nodes.length - (nodes.length > pageSize ? 2 : 1)].id,
      );
    }
  }
}

@ObjectType({ isAbstract: true })
export class PaginatedType<T extends GraphqlModel> {
  edges: EdgeType<T>[];
  nodes: T[];
  @Field()
  pageInfo: PageInfoType;

  constructor(nodes: T[], pageSize: number) {
    this.nodes = nodes;
    this.edges = nodes.map((node) => new EdgeType(node));
    if (nodes.length > pageSize) {
      this.edges = this.edges.slice(0, -1);
    }
    this.pageInfo = new PageInfoType(nodes, pageSize);
  }
}

export function Paginated<T extends GraphqlModel>(
  classRef: Type<T>,
  name?: string,
): Type<PaginatedType<T>> {
  @ObjectType(`${name ?? classRef.name}Edges`)
  abstract class EdgeTypeImpl<T extends GraphqlModel> extends EdgeType<T> {
    @Field(() => classRef)
    node: T;
  }

  @ObjectType({ isAbstract: true })
  class PaginatedTypeImpl extends PaginatedType<T> {
    @Field(() => [EdgeTypeImpl], { nullable: true })
    edges: EdgeTypeImpl<T>[];
  }
  return PaginatedTypeImpl;
}
