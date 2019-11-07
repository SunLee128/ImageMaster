create database imagemaster;

\c imagemaster

create TABLE images (
    userid INT,
    name TEXT,
    image_url TEXT,
    tags TEXT[],
    caption TEXT
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  password_digest TEXT
);

ALTER TABLE images ADD id SERIAL PRIMARY KEY;


