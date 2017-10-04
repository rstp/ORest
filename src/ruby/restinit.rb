require 'json'
require 'logger'
require 'sinatra'
require 'haml'
require 'odbutil'

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

db = ODBUtil.new
#db = OrientDB.new
#db.makeconnection('projets')
#enable :static

get '/' do
  puts "bonjour\n"
  redirect( "/clients/")
end
  
# form to show one client's details
get '/client/:id' do
  id = params[:id].to_i
  liste = db.getClientInfo(id)
  p liste
  redirect("/clients/") if liste.nil?
  liste.each {|x| p x} if DEBUG
  haml :show, :locals => { :c => liste }
end

# show list of all clients
get '/clients/?' do
#  nb = db.doQuery("select count(*) from client")[0]["count"].to_i    #db.countClients
  haml :list, :locals => { :cs => db.listClients }
end

# Show form to create new contact
get '/newclient' do
  # protected!
  l = db.getLastCID
  p l
  lastclient =  db.getClientInfo(l)
  l += 1
  lastclient['CID'] = l
  haml :form, :locals => {
     :c => lastclient,
     :action => '/create'
  }
end
# create new client
post '/create' do
  cid = params['CID']
  if db.newClient(params)
    redirect("/client/#{cid}")
  else
    redirect( "/clients/")
  end
end

post '/client/:id/destroy' do|id|
#   c = Contact.get(id)
#   c.destroy
   redirect "/clients/"
end
  
get '/set' do
  session[:foo] = Time.now
  session[:name] = "Robert" 
end

get '/fetch' do
  "Session name=#{session[:name]}\ntime=#{session[:foo]}"
end
