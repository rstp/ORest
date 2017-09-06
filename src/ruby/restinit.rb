require 'json'
require 'logger'
require 'sinatra'
require 'haml'
require 'OrientDB'

DEBUG = true

configure do
  enable :sessions
  set :port, 4568
  set :haml, :format => :html5
end

before do
#  content_type :html
end

helpers do
  def em(text)
    "<em><b>#{text}</b></em>"
  end

  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end
  
  def outnow(msg)
     STDOUT << "\n#{msg}\n"
     STDOUT.flush
  end
end # helpers

db = OrientDB.new
db.makeconnection('projets')
enable :static

get '/' do
  puts "bonjour\n"
end
  
# form to show one client's details
get '/client/:id' do
  #  "client id=#{params[:id]}"
  id = params[:id].to_i
  haml :show, :locals => { :c => db.findClient(id) }
end

# show list of all clients
get '/clients/?' do
  nb = db.countClients
  "voici les #{nb} contacts"
#  p db.listClients if DEBUG
  haml :list, :locals => { :cs => db.listClients }
end

# Show form to create new contact
get '/newclient' do
  # protected!
  l = db.lastClient
  nx =  db.findClient(l)
  nx['CID'] = l + 1
  haml :form, :locals => {
     :c => nx,
     :action => '/create'
  }
end
# create new client
post '/create' do
#  p params
  newClient(params)
  redirect("client/#{params['CID']}")
end

  
get '/set' do
  session[:foo] = Time.now
  session[:name] = "Robert" 
end

get '/fetch' do
  "Session name=#{session[:name]}\ntime=#{session[:foo]}"
end
