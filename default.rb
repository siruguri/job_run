require 'rubygems'
require "sinatra"
require "sinatra/reloader" if development?

get "/show_status" do
  task_id = params[:id]
  if task_id
    @status_file = File.join('tasks', '_status.txt')
    f = File.open(@status_file, 'r')

    @msg = '<p>'
    f.readlines.each do |l|
      @msg += "#{l}<p>"
    end
    @last_mod = File.mtime(@status_file)

    erb :status_message
  else
    "No such task!"
  end
end
