-- メモ
CREATE TABlE notes
(
  id SERIAL NOT NULL,
  title VARCHAR NOT NULL,
  body VARCHAR NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  PRIMARY KEY (id)
);

-- インデックスの追加
CREATE INDEX ON notes (updated_at);