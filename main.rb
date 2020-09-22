# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'logger'
require 'pg'

DB_HOST = 'localhost'
DB_USER = 'postgres'
DB_NAME = 'sinatra_practice_notes'

configure do
  set :connection, PG.connect(host: DB_HOST, user: DB_USER, dbname: DB_NAME)
end

helpers do
  # 全てのメモを取得
  def get_all_notes
    settings.connection.exec('SELECT * FROM notes ORDER BY updated_at DESC')
  end

  # メモの詳細を取得
  def get_note(id)
    result = settings.connection.exec('SELECT * FROM notes WHERE id = $1', [id])
    result[0]
  end

  # メモの新規作成
  def create_note(title, body)
    settings.connection.exec(
      'INSERT INTO notes (id, title, body, updated_at, created_at) values (DEFAULT, $1, $2, now(), now())',
      [title, body]
    )
  end

  # メモの削除
  def delete_note(id)
    settings.connection.exec('DELETE FROM notes WHERE id = $1', [id])
  end

  # メモの内容を変更
  def update_note(title, body, id)
    settings.connection.exec(
      'UPDATE notes SET title = $1, body = $2, updated_at = now() WHERE id = $3',
      [title, body, id]
    )
  end
end

# トップ画面
# ノート一覧
get '/notes' do
  @title = 'メモ'
  @notes = get_all_notes
  erb :notes
end

# メモ新規投稿画面
get '/notes/new' do
  @title = '新規投稿'
  erb :notes_new
end

# メモの新規投稿処理
post '/notes' do
  create_note(params[:note_title], params[:note_body])

  redirect to('/notes')
end

# メモ詳細画面
get '/notes/:id' do
  @title = 'メモ詳細'
  @note = get_note(params[:id])
  logger.info(msg: 'Get note', note: @note)

  erb :notes_detail
end

# メモの削除処理
delete '/notes/:id' do
  delete_note(params[:id])
  logger.info(msg: 'Delete note', note_id: params[:id])

  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

# メモの編集画面
get '/notes/:id/edit' do
  @title = 'メモ編集'
  @note = get_note(params[:id])

  erb :notes_edit
end

# メモの編集処理
patch '/notes/:id' do
  update_note(params[:note_title], params[:note_body], params[:id])

  # リダイレクトしてshow memoにいく
  redirect to("/notes/#{params[:id]}")
end
