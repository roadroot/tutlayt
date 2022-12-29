import * as Author from './schema/author.gql';
import * as Book from './schema/book.gql';
import { DocumentNode } from 'graphql';

export function resolveTypeDefs(): DocumentNode[] {
    return [Author, Book];
}