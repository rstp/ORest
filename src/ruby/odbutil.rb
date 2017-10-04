#
# ODButil
#
## Class to manage an OrientDB database
#  via a REST interface
#
# 
#attr_reader clientno, invoiceno, clientinfo

require 'rubygems'
require 'rest_client'
require 'json'
require 'open-uri'


class ODBUtil
   def initialize
      @prot = "http://"
      @host = "localhost:2480"
      @user = 'admin'
      @pwd = 'admin'
      @url = "#{@prot}#{@host}"
      @urlp = "#{@prot}#{@user}:#{@pwd}@#{@host}"
   end

   ## function create a new client
   #
   # @param none
   # @return object list of all clients [CID, nom, addresse, tele]
   
   def newClient(par)
     begin
#       par["cls"] = "clnt"
        pr = par.to_json
#        pr["cls"] = "client"
        ssql ="#{@urlp}/document/projets"
        p "#{ssql}  #{pr}"
        response = RestClient.post( ssql, pr, :content_type => :json, :accept => :json  )
        unless (response.code == 200)  #,params)
          return nil
        end
        return true
   rescue => e
       puts e
       return false
     end
  end
   
   ## function gets the list of clients
   #
   # @param none
   # @return object list of all clients [CID, nom, addresse, tele]
   
   def listClients
      begin
         response = getREST("select PID,nom,addresse, tele,CID from client")
         unless (response.code == 200)  #,params)
            return nil
         end
         unless (r = JSON.parse(response.body)["result"])       #.find {|x| x["PID"]==no}["CLIENTID"])
            return nil
         end
         r.map
       rescue => e
         puts e
         return nil
      end
  end
   
   ## function gets the client for an invoice
   #  via a RESTfull call to the OrientDB database
   #
   # @param no integer invoice number
   # @return client number as an integer or nil
   # @TODO query the invoice table instead of the projet table
   
#   def getClientForInvoice(no)
#      begin
#         response = getREST("select PID,CLIENTID from projet")
#         unless (response.code == 200)  #,params)
#            return nil
#         end
#         unless (r = JSON.parse(response.body)["result"].find {|x| x["PID"]==no}["CLIENTID"])
#            return nil
#         end
#         r
#       rescue => e
#         puts e
#         return nil
#      end
#  end
#
   ## function gets last valid client id
   #  via a RESTfull call to the OrientDB database
   #
   # @param none
   # @return integer last client CID
   
   def getLastCID
      sql = "select max(CID) as last from client"
      begin
         response = getREST(sql)
         r = JSON.parse(response.body)['result'][0]['last']
         r.to_i
       rescue => e
         puts e
         return nil
      end
  end

   ## function gets the client info
   #  via a RESTfull call to the OrientDB database
   #
   # @param invno integer client number
   # @return client info hash {:no, :nom, :addresse, :tele, } or nil
   
   def getClientInfo(no)
      sql = "select CID,nom,addresse,tele from client where CID='#{no}'"
      begin
         response = getREST(sql)
         r = JSON.parse(response.body)["result"][0]
       rescue => e
         puts e
         return nil
      end
  end

   ## function gets a document for a rid
   #  via a RESTfull call to the OrientDB database
   #
   # @param rid of orientdb document
   # @return document json or nil
   # TODO find and implement sql to retrieve a document from its rid
#   def getODoc(no)
#      sql = "select CID,nom,addresse,tele from client where CID='#{no}'"
#      begin
#         response = getREST(sql)
#         unless (response.code == 200)  #,params)
#            return nil
#         end
#         r = JSON.parse(response.body)["result"][0]
#         x = {
#            :nom => r["nom"],
#            :addresse => r["addresse"] || "noaddr",
#            :tele => r["tele"] || "000"
#            }
#            x
#       rescue => e
#         puts e
#         return nil
#      end
#  end
#
   ## function performs a general sql query
   #
   # @param sql  string the sql query
   # @return json result of the query or nil
  def doQuery(sql)
      begin
         response = getREST(sql)
         unless (response.code == 200)  #,params)
            return nil
         end
         unless (r = JSON.parse(response.body)["result"])
           return nil
         end
         r.map
      rescue => e
         puts e
         return nil
      end
  end
   ## function query REST
   #
   # @param sql query
   # @return HTTP response
   
   def  getREST(sql)
      ssql ="#{@urlp}/query/projets/sql/#{sql}"
      response = RestClient.get(URI::encode(ssql))
   end
   
end 
