
require 'orientdb4r'
require 'json'
require 'OrientDB'
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
  # @param DB [string] the database to connect to
  # @param user [string] the username, defaults to 'admin'
  # @param password [string] the user's password, defaults to 'admin'
  #
  # @return boolean connection status
  #
  ##
  def makeconnection(db, user='admin', password='admin')
    begin
      @client.connect :database => db, :user => user, :password => password
      @client.connected?
    rescue => err
#      puts "Error: cannot connect to db: #{err}"
      nil
    end
  end


  ## create a database 
  #
  # @param name [string] the database name
  # @param opts [object] containing user,password and storage type
  #
  # @return boolean database creation status
  #
  ##
  def createdb (name, opts={user: 'root', password: 'root', storage: :plocal})
    @client.create_database :database=>name, :user=>opts['user'], :password=>opts['password'], :storage=>:plocal
    @client.database_exists? :database=>name, :user=>'admin', :password=>'admin'
  end

  def disconnect
    @client.disconnect
  end
  
  ## find a client
  #
  # @param cid [string] the required client id (cid)
  #
  # @return object of all client
  ##
  def findClient(cid)
    oneclient = @client.query("select from client where CID=#{cid}")
    if oneclient.size === 0
      nil
    end
    oneclient[0]
  end
  
  ## list all clients
  #
  # @param none
  #
  # @return list of all clients
  ##
  def listClients
    liste = @client.query("select from client") || {}
  end

  ## count number of clients in table
  #
  # @param none
  #
  # @return integer count of all clients
  ##
  def countClients
    count = @client.query "select count(*) from client"
    count[0]['count'].to_i
  end

  ## next client id
  #
  # @param none
  #
  # @return integer last client id + 1
  ##
  def lastClient
    last = @client.query "select max(CID) as last from client"
    last[0]['last']
  end

  ## new client
  #
  # @param cl [object] properties of a client
  #
  # @return true/false success of client creation
  ##
  def newClient (cl)
    cl['CLASS'] = "Client"
    return @client.create_document( cl )
  end


#class OrientDB
end 
