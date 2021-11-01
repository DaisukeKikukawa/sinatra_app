# http://localhost:4567

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'yaml/store'
require 'securerandom'
require 'pg'
enable :method_override

def conn
  @conn ||= PG.connect(dbname: 'memos')
end

get '/memos' do
  @memos = conn.exec("SELECT * FROM memos_app")
  erb :index
end

post '/memos' do
  conn.exec("INSERT INTO memos_app (title, content) VALUES ($1, $2);", [params['title'], params['content']])
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |n|
  @edit = "/memos/#{params['id']}/edit"
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']])

  erb :show
end

delete '/memos/:id' do
  conn.exec('DELETE FROM memos_app WHERE id = $1;', [params['id']])

  redirect to('/memos')
end

get '/memos/:id/edit' do |n|
  @id = "/memos/#{params['id']}"
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']] )
  erb :edit
end

patch '/memos/:id' do
  conn.exec('UPDATE memos_app SET title = $1, content = $2 WHERE id = $3;', [params['title'], params['content'], params['id']])
  redirect to("/memos")
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
