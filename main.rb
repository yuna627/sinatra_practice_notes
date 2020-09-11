require 'sinatra'
require 'sinatra/reloader'
require 'json'

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
  @content = 'main contnt'
  erb :notes_new
end

post '/notes' do
  @title = 'main'
  @content = 'main contnt'
  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

get '/notes/1111' do
  @title = 'main'
  @content = 'main contnt'
  erb :note_detail
end

delete '/notes/1111' do
  @title = 'main'
  @content = 'main contnt'
  # リダイレクトしてメモアプリトップにいく
  redirect to('/notes')
end

get '/notes/1111/edit' do
  @title = 'main'
  @content = 'main contnt'
  erb :notes_edit
end

patch '/notes/1111/' do
  @title = 'main'
  @content = 'main contnt'
  # リダイレクトしてshow memoにいく
  redirect to('/notes/1111')
end
