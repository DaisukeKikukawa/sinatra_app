# http://localhost:4567

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'yaml/store'
require 'securerandom'
enable :method_override

get '/memos' do
  memo_files = Dir.glob("./db/*")
  @memo_files_array = memo_files.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do |n|
  @edit = "/memos/#{params['id']}/edit"
  memo_file = Dir.glob("./db/#{params['id']}.json")
  @memo_file_array = memo_file.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}

  file = File.open("./db/#{n}.json", "r")
  memo = JSON.load(file)
  @title = memo["title"]
  @content = memo["content"]

  erb :show
end

delete '/memos/:id' do
  File.delete("./db/#{params['id']}.json")
  redirect "/memos"
end

get '/memos/:id/edit' do
  @id = "/memos/#{params['id']}"
  memo_file = Dir.glob("./db/#{params['id']}.json")
  @memo_file_array = memo_file.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}
  erb :edit
end

post '/memos' do
  @title = h(params[:title])
  @content = h(params[:content])
  memo_id = SecureRandom.alphanumeric
  memos = {"memo_id"=>"#{memo_id}","title"=>@title, "content"=>@content}
  File.open("./db/#{memo_id}.json", 'w') do |file|
    JSON.dump(memos, file)
  end
  memo_files = Dir.glob("./db/*")
  @memo_files_array = memo_files.map {|files| JSON.parse(File.open(files).read, symbolize_names: true)}

  erb :index
end

patch '/memos/:id' do
  File.open("./db/#{params['id']}.json",'w') do |file|
    hash = {id: "#{params['id']}",title: params[:title],body: params[:body]}
    JSON.dump(hash,file)
  end
  redirect to("/memos")
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
