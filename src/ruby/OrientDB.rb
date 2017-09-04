
require 'orientdb4r'
require 'json'

##
#  Class to manage all accesses to the OrientDB database
#
class OrientDB
  attr_reader :client
  attr_reader :liste


  ## Initialize database
  # and the OrientDB database logger
  #
  # @param host [string] the host name or ip address, defaults to 'airstp'
  # @param port [integer] the port number where the OrientDB server responds, defaults to 2480
  #
  # @return none
  #
  ##
  def initialize(host = 'airstp', port='2480')
#    Orientdb4r.logger = Logger.new('orientdb.log')
#    Orientdb4r.logger.level = Logger::DEBUG

    @client = Orientdb4r.client :host => host, :port => port, :ssl => false

  end

  ## Establish a connection to the database
  #
  # @param database [string] the database to connect to
  # @param user [string] the username, defaults to 'admin'
  # @param password [string] the user's password, defaults to 'admin'
  #
  # @return object nil or the client's connection
  #
  ##
  def makeconnection(database, user='admin', password='admin')
    begin
      @client.connect :database => database, :user => user, :password => password
    rescue => err
#      puts "Error: cannot connect to db: #{err}"
      nil
    end
  end

  def disconnect
    @client.disconnect
  end
  
  
  def listClients
    
#    begin
#      makeconnect(database)

    @liste = @client.query("select CID,nom,addresse,tele from client") || {}

#      response.each do |r|
#         puts "nom => #{r['nom']} addresse => #{r['addresse']}"
#         :tele => r["tele"] || "000"
#      end
#      @client.disconnect
#    rescue => err
#      puts "problem reading database = #{err}"
#    end

  end

  def countClients
    count = @client.query "select count(*) from client"
    count[0]['count']    
  end

#end class OrientDB
end