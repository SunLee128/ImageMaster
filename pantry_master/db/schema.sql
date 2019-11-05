create database pantrymaster;

\c pantrymaster

create TABLE inventory (
    id SERIAL PRIMARY KEY,
    name TEXT,
    image_url TEXT
);

create TABLE recipe (
    
)

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  password_digest TEXT;
);

INSERT INTO users (email) VALUES ('sunlee128@gmail.com');