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
 * isAdmin ���� 0�� ��� �Ϲ� ȸ��
 * isAdmin ���� 1�� ��� ������
 * 
 * */

CREATE TABLE IF NOT EXISTS feed (
  no      BIGINT(16) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id      VARCHAR(32),
  jsonobj VARCHAR(4096),
  INDEX idx1(id)
);

/**
�Խ���
type 0 ���������
type 1 ȭ�й�����
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
QnA �Խ���
 */

CREATE TABLE IF NOT EXISTS qna (
  no      BIGINT(16) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id      VARCHAR(32),
  jsonobj VARCHAR(4096),
  title varchar(500),
  INDEX idx1(id)
);