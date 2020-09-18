# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'pg'

LOGFILE = 'sinatra.log'

logger = Logger.new(LOGFILE)

# DBの読み込み
def load_data
  connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'sinatra_practice_notes')
  connection.exec('SELECT * FROM notes ORDER BY updated_at DESC')
end

def get_data(id)
  connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'sinatra_practice_notes')
  result = connection.exec('SELECT * FROM notes WHERE id = $1', [id])
  result[0]
end

# トップ画面
# ノート一覧
get '/notes' do
  @title = 'メモ'
  @notes = load_data
  erb :notes
end

# メモ新規投稿画面
get '/notes/new' do
  @title = '新規投稿'
  erb :notes_new
end

# メモの新規投稿処理
post '/notes' do
  connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'sinatra_practice_notes')
  connection.exec(
    'INSERT INTO notes(id,title,body,updated_at,created_at) values(DEFAULT,$1,$2,now(),now())',
    [params[:note_title], params[:note_body]]
  )

  redirect to('/notes')
end

# メモ詳細画面
get '/notes/:id' do
  @title = 'メモ詳細'
  @note = get_data(params[:id])
  logger.info(msg: 'note', note: @note)

  erb :notes_detail
end

# メモの削除処理
delete '/notes/:id' do
  connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'sinatra_practice_notes')
  connection.exec('DELETE FROM notes WHERE id = $1', [params[:id]])
  logger.info(msg: 'Deleted', note_id: params[:id])

  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

# メモの編集画面
get '/notes/:id/edit' do
  @title = 'メモ編集'
  @note = get_data(params[:id])

  erb :notes_edit
end

# メモの編集処理
patch '/notes/:id' do
  connection = PG.connect(host: 'localhost', user: 'postgres', dbname: 'sinatra_practice_notes')
  connection.exec(
    'UPDATE notes SET title = $1, body = $2, updated_at = now() WHERE id = $3',
    [params[:note_title], params[:note_body], params[:id]]
  )

  # リダイレクトしてshow memoにいく
  redirect to("/notes/#{params[:id]}")
end
