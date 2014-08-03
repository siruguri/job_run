require "sinatra/base"
require "sinatra/reloader"

class JobRunApp < Sinatra::Base
  set root: "/home/sameer/digital_strategies/clients/mgp/job_run"
  set checking_root: Dir.pwd

  configure :development do
    register Sinatra::Reloader
  end

  get "/show_status" do
    @msg = ''

    task_id = params[:id]
    if task_id
      begin
        @status_file = File.join("../tasks/#{task_id}", '_status.txt')
        f = File.open(@status_file, 'r')

        @msg += '<p>'
        f.readlines.each do |l|
          @msg += "#{l}<p>"
        end
        @last_mod = File.mtime(@status_file)
        f.close
      rescue Errno::ENOENT => e
        @msg += "<p>Couldn't open file<p>"
      end

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

      @@pid=Process.spawn("./plan.sh", chdir: dir_loc)

      @msg = "Started process #{@@pid} -- \n---\n"
      Process.detach @@pid

      f=File.open("#{dir_loc}/_status.txt", 'a')
      f.write(@msg)
      f.close
      
      redirect to("/show_status?id=#{task_id}")
    end
  end
end
