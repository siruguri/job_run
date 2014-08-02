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

get "/run_job" do 
  task_id = params[:id]
  if !Dir.exists? "../tasks/#{task_id}" || !File.exists?(File.join "../tasks/#{task_id}", "plan.sh")
    @msg = "ID invalid"
    @last_mod = "N/A"
    erb :status_message
  else
    dir_loc="../tasks/#{task_id}"

    pid=spawn("../tasks/#{task_id}/plan.sh")
    @msg = "Started process #{pid}"

    f=File.open("#{dir_loc}/_status.txt", 'a')
    f.write(@msg)
    f.close
    
    redirect to("/show_status")
  end
end

