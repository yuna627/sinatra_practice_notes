require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'logger'

LOGFILE = 'sinatra.log'.freeze
DATAFILE = 'data/notes.json'.freeze

logger = Logger.new(LOGFILE)

# データの書き込み
def write_data(data)
  File.open(DATAFILE, 'w') do |note_file|
    JSON.dump(data, note_file)
  end
end

# データの読み込み
# データが存在しないときは初期データを返す
def load_data
  data = { 'last_id' => 0, 'notes' => {} }
  return data unless File.exist?(DATAFILE)

  File.open(DATAFILE) do |note_file|
    data = JSON.load(note_file)
  end
  data
end

# トップ画面
# ノート一覧
get '/notes' do
  @title = 'メモ'
  data = load_data
  @notes = data['notes']
  erb :notes
end

# メモ新規投稿画面
get '/notes/new' do
  @title = '新規投稿'
  erb :notes_new
end

# メモの新規投稿処理
post '/notes' do
  data = load_data
  data['last_id'] += 1
  data['notes'][data['last_id'].to_s] = {
    id: data['last_id'],
    title: params[:note_title],
    body: params[:note_body]
  }

  write_data(data)

  redirect to('/notes')
end

# メモ詳細画面
get '/notes/:id' do
  @title = 'メモ詳細'
  data = load_data
  @note = data['notes'][params[:id]]
  erb :notes_detail
end

# メモの削除処理
delete '/notes/:id' do
  data = load_data
  deleted = data['notes'].delete(params[:id].to_s)
  logger.info(msg: 'Deleted', note: deleted)
  write_data(data)
  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

# メモの編集画面
get '/notes/:id/edit' do
  @title = 'メモ編集'
  data = load_data
  @note = data['notes'][params[:id]]
  erb :notes_edit
end

# メモの編集処理
patch '/notes/:id' do
  data = load_data
  data['notes'][params[:id]]['title'] = params[:note_title]
  data['notes'][params[:id]]['body'] = params[:note_body]
  write_data(data)
  # リダイレクトしてshow memoにいく
  redirect to("/notes/#{params[:id]}")
end
