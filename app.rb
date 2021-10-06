# http://localhost:4567

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'yaml/store'
require 'securerandom'
require 'pg'
enable :method_override

get '/memos' do
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec("SELECT * FROM memos_app")
  erb :index
end

post '/memos' do
  conn = PG.connect(dbname: 'memos')
  conn.exec("INSERT INTO memos_app (title, content) VALUES ($1, $2);", [params['title'], params['content']])
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |n|
  @edit = "/memos/#{params['id']}/edit"
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']])

  erb :show
end

delete '/memos/:id' do
  conn = PG.connect(dbname: 'memos')
  conn.exec('DELETE FROM memos_app WHERE id = $1;', [params['id']])

  redirect to('/memos')
end

get '/memos/:id/edit' do |n|
  @id = "/memos/#{params['id']}"
  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']] )
  erb :edit
end

post '/memos' do
  @id = SecureRandom.uuid
  @title = params[:title]
  @content = params[:content]
  conn = PG.connect(dbname: 'memos')
  conn.exec("INSERT INTO memos_app (title, content) VALUES ( '#{params['title']}', '#{params['content']}');")

  erb :index
end

patch '/memos/:id' do
  conn = PG.connect(dbname: 'memos')
  conn.exec('UPDATE memos_app SET title = $1, content = $2 WHERE id = $3;', [params['title'], params['content'], params['id']])
  redirect to("/memos")
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
