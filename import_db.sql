DROP TABLE if exists users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);


DROP TABLE if exists questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  /*
  does this point to users or to question_follows
  */
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if exists question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE if exists replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE if exists question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Christopher', 'Button'),
  ('Samuel', 'Mak'),
  ('Miyamoto', 'Musashi'),
  ('Cup', 'Jenkins'),
  ('Benq', 'Hp');


INSERT INTO
  questions (title, body, user_id)
VALUES
  ('SQL question', 'How do I insert comments into SQL?', (SELECT id
    FROM users WHERE lname = 'Button') ),
  ('Ruby question', 'What is a Ruby?@@?!', (SELECT id
    FROM users WHERE lname = 'Hp' )),
  ('Ruby question', 'What is a gem?@@?!', (SELECT id
    FROM users WHERE lname = 'Hp' )),
  ('Some other title', 'How do I 1337 haX07', (SELECT id
    FROM users WHERE lname = 'Jenkins' ));

INSERT INTO
  replies (body, question_id, parent_id, user_id)
VALUES
  ('Here is some words for the body', 1, NULL, 2),
  ('Reply 2', 1, NULL, 2),
  ('Reply 3', 3, NULL, 1),
  ('Reply 3.14', 3, 2, 2);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (5, 2),
  (1, 2),
  (2, 2),
  (3, 2),
  (5, 1),
  (1, 3),
  (4, 5),
  (4, 1),
  (4, 2),
  (4, 3);
