-- CREATE DATABASE mybookmark;
-- USE mybookmark;

CREATE TABLE bookmark (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NOT NULL,
  entry_id INT UNSIGNED NOT NULL,
  comment TEXT,
  created_on TIMESTAMP DEFAULT 0,
  PRIMARY KEY (id),
  KEY (user_id, entry_id)
) DEFAULT CHARSET=BINARY;

CREATE TABLE entry (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  url VARCHAR(255) DEFAULT NULL,
  title VARCHAR(255) DEFAULT NULL,
  created_on TIMESTAMP DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY (url)
) DEFAULT CHARSET=BINARY;

CREATE TABLE user (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (name)
) DEFAULT CHARSET=BINARY;

INSERT INTO user (name) VALUES ('onishi');
