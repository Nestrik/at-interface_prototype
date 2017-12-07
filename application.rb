require 'sinatra'

Dir.foreach('app') { |x| require "./app/#{x}" if File.file?("app/#{x}") }
test_executor = TestExecutor.new


get "/" do
  erb :main
end

post '/run' do
  test_executor.testprepare('selenium_blizko')
end

get '/run/log' do
  test_executor.log
end

get '/js' do
  send_file 'app/public/application.js'
end

get '/app.css' do
  send_file 'app/public/app.css'
end

get '/config' do
  erb :config
end

post '/config' do
  test_executor.create_config(params)
end

post '/config/validate' do
  error = test_executor.run_params_validation(request.body.read)
  if error == nil then
    create_config
  else
    #вывести ошибки на странице
  end
end
