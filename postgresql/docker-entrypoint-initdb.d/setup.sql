CREATE DATABASE post;

CREATE TABLE IF NOT EXISTS post.post_info (
  local_publid_org_code NUMBER(5) NOT NULL,
  old_zip_code CHAR(5) NOT NULL,
  zip_code CHAR(7) NOT NULL,
  kana_prefecture VARCHAR(30) NOT NULL,
  kana_city VARCHAR(255) NOT NULL,
  kana_town VARCHAR(255) NOT NULL,
  kanji_prefecture VARCHAR(30) NOT NULL,
  kanji_city VARCHAR(255) NOT NULL,
  kanji_town VARCHAR(255) NOT NULL,
  reserve1 CHAR(1) NOT NULL,
  reserve2 CHAR(1) NOT NULL,
  reserve3 CHAR(1) NOT NULL,
  reserve4 CHAR(1) NOT NULL,
  reserve5 CHAR(1) NOT NULL,
  reserve6 CHAR(1) NOT NULL
)
