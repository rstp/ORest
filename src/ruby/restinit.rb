require 'json'
require 'logger'
require 'sinatra'
require 'haml'
require 'orientdb4r'

##
# RESTorient Class to manage the REST server
#
#
class RESTorient # < Sinatra::Base

#  attr_reader :log
  
  ## Initialize application
  #
  # @param none
  #
  # @return none
  #
  ##
  def initialize
     @CLASS = "Client"
    # setup a logger for @log.debug(<string>) also for info warn close
    # will print something like this :    #    W, [2017-07-11T12:09:29.243266 #25635]  WARN -- robert: "message"

#      file = File.open('rest.log', 'a')
#      @log = Logger.new(file)
#      original_formatter = Logger::Formatter.new
#      @log.formatter = proc {|severity, datetime, progname, msg|
#          original_formatter.call(severity, datetime, "robert", msg.dump)
#      }
      @client = Orientdb4r.client :host => 'localhost', :port => 2480, :ssl => false
      @client.connect :database => 'projets', :user => 'admin', :password => 'admin'
      puts countclient
  end # initialize

#  helpers do
#    def em(text)
#      "<em><b>#{text}</b></em>"
#    end
#  
#    def protected!
#      return if authorized?
#      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
#      halt 401, "Not authorized\n"
#    end
#  
#    def authorized?
#      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
#      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
#    end
#    
#    def outnow(msg)
#       STDOUT << "\n#{msg}\n"
#       STDOUT.flush
#    end
  def countclient
    count = @client.query "select count(*) from #{@CLASS}"
    count[0]['count']    
  end
  def showclient
    liste = @client.query "SELECT from #{@CLASS}"
#    p liste
#    liste.each do  |c|
#       puts "name = #{c['nom']}\ttele = #{c['tele']}\n"
#      end       
  end
#  end # helpers
end #RESTorient

db = RESTorient.new

  get '/' do
    puts "bonjour\n"
  end
  
  get '/contacts/?' do
    nb = db.countclient
    puts "voici les #{nb} contacts"
    @liste = db.showclient
#    erb :liste

    haml :list, :locals => { :cs => db.showclient }
  end
  
  get '/allo' do
    puts "Allo Robert"
  end

  get '/halt' do
    halt 500
  end

