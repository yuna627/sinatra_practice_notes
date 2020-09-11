# sinatra_practice_notes

## top

|Method |Path|Descriptoin|
|--|--|--|
|GET|/notes|メモ一覧を取得|

## new memo

|Method |Path|Descriptoin|
|--|--|--|
|GET|/notes/new|メモの作成のページを表示|
|POST|/notes/|新しいメモの作成|

## show memo

|Method|Path|Descriptoin|
|--|--|--|
|GET|/notes/123|note_id = 123のメモ詳細を取得|
|DELETE|/notes/123|note_id = 123のメモ内容を削除|

## edit memo

|Method |Path|Descriptoin|
|--|--|--|
|GET|/notes/123/edit|note_id = 123のメモ詳細をメモ編集画面で取得|
|PATCH|/notes/123|note_id = 123のメモ内容を変更|
