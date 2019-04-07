require 'sinatra'
require 'rack/cors'
require 'pony'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/send_email', :methods => [:post]
  end
end

set :mail_options, {
	:to => 'alexandrabrinncampbell@gmail.com',
	:from => 'alexandrabrinncampbell@gmail.com',
	:via => :smtp,
	:via_options => {
		:address => 'smtp.sendgrid.net',
		:port => 587,
		:domain => 'heroku.com',
		:user_name => ENV['SENDGRID_USERNAME'],
		:password => ENV['SENDGRID_PASSWORD'],
		:authentication => :plain
	}
}

get '/' do
  "<h1 style='color: #186A3B'>WORKING...!!!</h1>"
  "<form action='https://simple-test-form.herokuapp.com/send_email' method='POST'>
    <div class='form-group'>
      <label>Name</label>
      <input type='text' name='name' class='form-control' placeholder='Name' required>
    </div>
    <div class='form-group'>
      <label>Your Email</label>
      <input type='email' name='email' class='form-control' placeholder='Your E-mail' required>
    </div>
    <div class='form-group'>
      <label>Subject</label>
      <input type='text' name='subject' class='form-control' placeholder='Subject' required>
    </div>
    <div class='form-group'>
      <textarea class='form-control' name='message' rows='7' placeholder='Message' required>
      </textarea>
    </div>
    <div class='text-center'>
      <input type='submit' value='Submit' class='btn btn-primary'>
    </div>
  </form>"
end

post '/send_email' do
  senders_name = params[:name]
  senders_email = params[:email]
  message = params[:message]
  subject = params[:subject]
  body = "#{senders_name}, #{senders_email}\n\n#{subject}\n\n#{message}"
  settings.mail_options[:body] = body
  settings.mail_options[:subject] = "New message via contact form"

  Pony.mail(settings.mail_options)
  redirect "http://goats-guide.herokuapp.com"
end
