require File.expand_path('../job_run_app.rb', __FILE__)
use Rack::ShowExceptions
run JobRunApp.new
