CREATE TABLE question (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    body VARCHAR NOT NULL
);

CREATE TABLE user_profile (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    phone VARCHAR NOT NULL UNIQUE,
    picture VARCHAR
);

CREATE TABLE credentials (
    id SERIAL NOT NULL,
    password VARCHAR NOT NULL,
    CONSTRAINT user_profile_fk FOREIGN KEY(id) REFERENCES user_profile(id)
);

