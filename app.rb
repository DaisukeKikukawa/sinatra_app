# http://localhost:4567

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'yaml/store'
require 'securerandom'
require 'pg'
enable :method_override

get '/memos' do
  # memo_files = Dir.glob("./db/*")
  # @memo_files_array = memo_files.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}

  # conn = PG.connect(dbname: 'memos')
  # @memos = conn.exec('SELECT * FROM memos_app;')

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
  # file = File.open("./db/#{n}.json", "r")
  # memo = JSON.load(file)
  # @title = memo["title"]
  # @content = memo["content"]

  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']])

  erb :show
end

delete '/memos/:id' do
  # File.delete("./db/#{params['id']}.json")
  # redirect "/memos"
  conn = PG.connect(dbname: 'memos')
  conn.exec('DELETE FROM memos_app WHERE id = $1;', [params['id']])

  redirect to('/memos')
end

get '/memos/:id/edit' do |n|
  @id = "/memos/#{params['id']}"
  # file = File.open("./db/#{n}.json", "r")
  # memo = JSON.load(file)
  # @title = memo["title"]
  # @content = memo["content"]

  conn = PG.connect(dbname: 'memos')
  @memos = conn.exec('SELECT * FROM memos_app WHERE id = $1;', [params['id']] )
  erb :edit
end

post '/memos' do
  # p "post!!!!!"

  # binding.irb

  @id = SecureRandom.uuid
  @title = params[:title]
  @content = params[:content]
  # memo_id = SecureRandom.alphanumeric
  # memos = {"memo_id"=>"#{memo_id}","title"=>@title, "content"=>@content}
  # File.open("./db/#{memo_id}.json", 'w') do |file|
  #   JSON.dump(memos, file)
  # end
  # memo_files = Dir.glob("./db/*")
  # @memo_files_array = memo_files.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}

  # conn = PG.connect( dbname: 'memos')
  # conn.exec("INSERT INTO memos_app (id, title, content) VALUES ('#{@id}', '#{@title}', '#{@content}')")

  conn = PG.connect(dbname: 'memos')
  conn.exec("INSERT INTO memos_app (title, content) VALUES ( '#{params['title']}', '#{params['content']}');")

  erb :index
end

patch '/memos/:id' do
  # File.open("./db/#{params['id']}.json",'w') do |file|
  #   hash = {id: "#{params['id']}",title: params[:title],body: params[:body]}
  #   JSON.dump(hash,file)
  # end

  conn = PG.connect(dbname: 'memos')
  conn.exec('UPDATE memos_app SET title = $1, content = $2 WHERE id = $3;', [params['title'], params['content'], params['id']])
  redirect to("/memos")
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
