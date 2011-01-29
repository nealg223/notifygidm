require 'sinatra'
require 'sinatra/sequel'

set :product_name, 'Get It Done Machine'
set :product_keywords, 'widget, acme, awesome, cool'
set :placeholder_email, 'email@example.com'
set :database, ENV['DATABASE_URL'] || 'sqlite://notify-me.db'

migration "create subscriptions" do
  database.create_table :subscriptions do
    primary_key :id
    String      :email,      :null => false
    DateTime    :created_at, :null => false
  end
end

class Subscription < Sequel::Model
end

get '/' do
  erb :index
end

post '/subscribe' do
  if params[:email].empty?
    halt 'Email is required to subscribe!'
  end
  @email = params[:email]
  Subscription.insert(:email => @email, :created_at => DateTime.now) unless Subscription.find(:email => @email)
  erb :success
end

__END__

@@ layout
<!DOCTYPE html>
<html>
  <head>
    <meta content='<%= settings.product_name %>' name='description' />
    <meta content='<%= settings.product_keywords %>' name='keywords' />
    <title><%= "#{settings.product_name}" %></title>
    <link href='/reset.css' rel='stylesheet' />
    <link href='/notify-me.css' rel='stylesheet' />
  </head>
  <body>
    <div id='container'>
      <%= yield %>
    </div>
    <script src='https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js'></script>
    <script src='/notify-me.js'></script>
  </body>
</html>

@@ index
<div id='boxtop'></div>
<div id='banner'>
  <h1><%= "The #{settings.product_name} is in development" %></h1>
</div>
<div id='boxmain'>
  <p>Enter your email and we will inform you when the machine is ready to operate.</p>
  <div id='subscribe'>
    <form action='/subscribe' method='post'>
      <label for='email'>Email</label>
      <input type='text' name='email' value='<%= settings.placeholder_email %>'></input>
      <div class='button-container'>
        <button value='submit' class='awesome'>Submit</button>
      </div>
    </form>
  </div>
</div>

@@ success
<div id='boxtop'></div>
<div id='banner'>
  <h1>Soon. Until then, prepare.</h1>
</div>
<div id='boxmain'>
  <h3><%= "We'll contact you via #{@email} when the #{settings.product_name} charges." %></h3>
  <div class='button-container'>
    <a href='/' class='awesome enabled'>Home</a>
  </div>
</div>