require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'logger'

logger = Logger.new('sinatra.log')
def write_data(data)
  File.open('data/notes.json', 'w') do |note_file|
    JSON.dump(data, note_file)
  end
end

def load_data
  data = { 'last_id' => 0, 'notes' => {} }
  return data unless File.exist?('data/notes.json')

  File.open('data/notes.json') do |note_file|
    data = JSON.load(note_file)
  end
  data
end

get '/notes' do
  @title = 'メモ'
  data = load_data
  @notes = data['notes']
  erb :notes
end

get '/notes/new' do
  @title = '新規投稿'
  erb :notes_new
end

post '/notes' do
  @data = load_data
  @data['last_id'] += 1
  @data['notes'][@data['last_id'].to_s] = {
    id: @data['last_id'],
    title: params[:note_title],
    body: params[:note_body]
  }

  write_data(@data)

  redirect to('/notes')
end

get '/notes/:id' do
  @title = 'メモ詳細'
  data = load_data
  @note = data['notes'][params[:id]]
  erb :notes_detail
end

delete '/notes/:id' do
  data = load_data
  deleted = data['notes'].delete(params[:id].to_s)
  logger.info(msg: 'Deleted', note: deleted)
  write_data(data)
  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

get '/notes/:id/edit' do
  @title = 'メモ編集画面'
  data = load_data
  @note = data['notes'][params[:id]]
  erb :notes_edit
end

patch '/notes/:id' do
  data = load_data
  data['notes'][params[:id]]['title'] = params[:note_title]
  data['notes'][params[:id]]['body'] = params[:note_body]
  write_data(data)
  # リダイレクトしてshow memoにいく
  redirect to("/notes/#{params[:id]}")
end
