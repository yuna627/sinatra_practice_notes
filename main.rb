require 'sinatra'
require 'sinatra/reloader'

get '/notes' do
  @title = 'Notes'
  @content = 'Notes'

  @notes = [{ "id": 1, "title": 'Test1', "body": 'This is test 1!' },
            { "id": 2, "title": 'Test2', "body": 'This is test 2!' }]
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
