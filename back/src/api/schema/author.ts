import Book from './book';

type Author = {
	name: string;
	books?: Book[];
};

export default Author;
