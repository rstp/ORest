require 'json'
require 'logger'
require 'sinatra'
require 'haml'
require 'OrientDB'


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
  
  get '/contacts/?' do
    nb = db.countClients
    puts "voici les #{nb} contacts"
#    @liste = db.listClients
#    erb :liste

    haml :list, :locals => { :cs => db.listClients }
  end
  
  get '/allo' do
    puts "Allo Robert"
  end

  get '/halt' do
    halt 500
  end
