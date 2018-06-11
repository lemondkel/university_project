CREATE DATABASE IF NOT EXISTS mysns
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_unicode_ci;
USE mysns;

CREATE TABLE IF NOT EXISTS user (
  id       VARCHAR(32) PRIMARY KEY,
  name     VARCHAR(32),
  password VARCHAR(32),
  isAdmin  INT       DEFAULT 0,
  ts       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/*
 * isAdmin 값이 0일 경우 일반 회원
 * isAdmin 값이 1일 경우 관리자
 * 
 * */

CREATE TABLE IF NOT EXISTS feed (
  no      BIGINT(16) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id      VARCHAR(32),
  jsonobj VARCHAR(4096),
  INDEX idx1(id)
);

/**
게시판
type 0 음료수정보
type 1 화학물정보
 */
CREATE TABLE IF NOT EXISTS info (
  no      BIGINT(16) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id      VARCHAR(32),
  jsonobj VARCHAR(4096),
  title varchar(500),
  material varchar(500),
  hashtag varchar(500),
  type int default 0,
  INDEX idx1(id)
);

/**
QnA 게시판
 */

CREATE TABLE IF NOT EXISTS qna (
  no      BIGINT(16) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id      VARCHAR(32),
  jsonobj VARCHAR(4096),
  title varchar(500),
  INDEX idx1(id)
);