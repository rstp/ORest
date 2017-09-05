require 'json'
require 'logger'
require 'sinatra'
require 'haml'
require 'OrientDB'

configure do
  enable :sessions
  set :port, 4568
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
  
get '/client/:id' do
#  "client id=#{params[:id]}"
  id = params[:id].to_i
  haml :show, :locals => { :c => db.findClient(id)[0] }
end

get '/clients' do
#    unless protected
  nb = db.countClients
  "voici les #{nb} contacts"
#    @liste = db.listClients
#    erb :liste

  haml :list, :locals => { :cs => db.listClients }
#    end
end
  
get '/set' do
  session[:foo] = Time.now
  session[:name] = "Robert" 
end

get '/fetch' do
  "Session name=#{session[:name]}\ntime=#{session[:foo]}"
end
