-- exec into the pod first 
-- kubectl exec -t -i postgres-sts-0 -- psql -U postgres -d postgres
-- create users table
CREATE TABLE users (id SERIAL PRIMARY KEY,name VARCHAR(100));

-- create users
INSERT INTO users (name) VALUES ('user - 1');
INSERT INTO users (name) VALUES ('user - 2');
INSERT INTO users (name) VALUES ('user - 3');
INSERT INTO users (name) VALUES ('user - 4');
INSERT INTO users (name) VALUES ('user - 5');

-- select all users
SELECT * FROM users;
