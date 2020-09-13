require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'logger'

logger = Logger.new('sinatra.log')

get '/notes' do
  @title = 'Notes'
  File.open('data/notes.json') do |note_file|
    note = JSON.load(note_file)
    p note
    @notes = note['notes']
  end

  erb :notes
end

get '/notes/new' do
  @title = 'main'
  erb :notes_new
end

post '/notes' do
  @title = 'main'
  # ファイルの読み込み
  File.open('data/notes.json') do |note_file|
    @data = JSON.load(note_file)
    @data['last_id'] += 1
    @data['notes'][@data['last_id'].to_s] = {
      id: @data['last_id'],
      title: params[:note_title],
      body: params[:note_body]
    }
  end
  # 書き込み
  File.open('data/notes.json', 'w') do |note_file|
    JSON.dump(@data, note_file)
  end
  redirect to('/notes')
end

get '/notes/:id' do
  @title = 'edit'
  # ファイルの読み込み
  File.open('data/notes.json') do |note_file|
    @data = JSON.load(note_file)
    @note = @data['notes'][params[:id]]
  end
  erb :notes_detail
end

post '/notes/:id/delete' do
  @title = 'main'
  File.open('data/notes.json') do |note_file|
    @data = JSON.load(note_file)
    deleted = @data['notes'].delete(params[:id].to_s)
    logger.info(msg: 'Deleted', note: deleted)
  end
  # 書き込み
  File.open('data/notes.json', 'w') do |note_file|
    JSON.dump(@data, note_file)
  end
  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

get '/notes/:id/edit' do
  @title = 'main'
  # ファイルの読み込み
  File.open('data/notes.json') do |note_file|
    @data = JSON.load(note_file)
    @note = @data['notes'][params[:id]]
  end
  erb :notes_edit
end

post '/notes/:id' do
  @title = 'main'
  File.open('data/notes.json') do |note_file|
    @data = JSON.load(note_file)
    @data['notes'][params[:id]][:title] = params[:note_title]
    @data['notes'][params[:id]][:body] = params[:note_body]
  end
  # 書き込み
  File.open('data/notes.json', 'w') do |note_file|
    JSON.dump(@data, note_file)
  end
  # リダイレクトしてshow memoにいく
  redirect to("/notes/#{params[:id]}")
end
