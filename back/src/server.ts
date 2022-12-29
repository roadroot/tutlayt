import dotenv from 'dotenv';
import { loadFiles } from '@graphql-tools/load-files';
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';

import Author from './api/schema/author';
import Query from './api/schema/query';

export const authors: Author[] = [
	{
		name: '#A1',
		books: [
			{
				name: '#A1B1',
			},
			{
				name: '#A1B2',
			},
			{
				name: '#A1B3',
			},
		],
	},
	{
		name: '#A2',
		books: [
			{
				name: '#A2B1',
			},
			{
				name: '#A2B2',
			},
			{
				name: '#A2B3',
			},
		],
	},
	{
		name: '#A3',
		books: [
			{
				name: '#A3B1',
			},
			{
				name: '#A3B2',
			},
			{
				name: '#A3B3',
			},
		],
	},
];

dotenv.config();

const typeDefs = await loadFiles('**/*.gql', {
	recursive: true,
});

const resolvers = {
	Query: {
		author: (_: Query, { name }: { name: string }) => {
			console.log(authors.find((auth) => auth.name == name));
			return authors.find((auth) => auth.name == name);
		},
	},
};

const server = new ApolloServer({
	typeDefs,
	resolvers,
});

const { url } = await startStandaloneServer(server);
console.log(`🚀 Server ready at ${url}`);
