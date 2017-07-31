#
# ODButil
#
require 'rubygems'
require 'rest_client'
require 'json'
require 'open-uri'


## Class to manage an OrientDB database
#
# 
#attr_reader clientno, invoiceno, clientinfo

class ODBUtil
   def initialize
      @prot = "http://"
      @host = "airstp:2480"
      @user = 'admin'
      @pwd = 'admin'
      @url = "#{@prot}#{@host}"
      @urlp = "#{@prot}#{@user}:#{@pwd}@#{@host}"
   end

   ## function query REST
   #
   # @param sql query
   # @return HTTP response
   
   def  getREST(sql)
      ssql ="#{@urlp}/query/projets/sql/#{sql}"
      response = RestClient.get(URI::encode(ssql))
   end
   
   #function gets the client for an invoice
   #  via a RESTfull call to the OrientDB database
   #
   # @param no integer invoice number
   # @return client number as an integer or nil
   # @TODO query the invoice table instead of the projet table
   
   def getClientForInvoice(no)
      begin
         response = getREST("select PID,CLIENTID from projet")
         unless (response.code == 200)  #,params)
            return nil
         end
         unless (r = JSON.parse(response.body)["result"].find {|x| x["PID"]==no}["CLIENTID"])
            return nil
         end
         r
       rescue => e
         puts e
         return nil
      end
  end


   #function gets the client info
   #  via a RESTfull call to the OrientDB database
   #
   # @param invno integer client number
   # @return client info hash {:no, :nom, :addresse, :tele, } or nil
   
   def getClientInfo(no)
      sql = "select CID,nom,addresse,tele from client where CID='#{no}'"
      begin
         response = getREST(sql)
         unless (response.code == 200)  #,params)
            return nil
         end
         r = JSON.parse(response.body)["result"][0]
         x = {
            :nom => r["nom"],
            :addresse => r["addresse"] || "noaddr",
            :tele => r["tele"] || "000"
            }
            x
       rescue => e
         puts e
         return nil
      end
  end

   #function gets a document for a rid
   #  via a RESTfull call to the OrientDB database
   #
   # @param rid of orientdb document
   # @return document json or nil
   # TODO find and implement sql to retrieve a document from its rid
   def getODoc(no)
      sql = "select CID,nom,addresse,tele from client where CID='#{no}'"
      begin
         response = getREST(sql)
         unless (response.code == 200)  #,params)
            return nil
         end
         r = JSON.parse(response.body)["result"][0]
         x = {
            :nom => r["nom"],
            :addresse => r["addresse"] || "noaddr",
            :tele => r["tele"] || "000"
            }
            x
       rescue => e
         puts e
         return nil
      end
  end

   #function performs a general sql query
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
         r
      rescue => e
         puts e
         return nil
      end
  end

end 
#class FindClientInfo

#a = ODBUtil.new
#[3,8,9].each { |no| 
#   puts "infoclient for projet no #{no}="
#   puts  a.getClientInfo(a.getClientForInvoice(no))
#}

#r = a.doQuery("select from client where @rid='#32:0'")
#p r
#p r[0]["@rid"]
#r[0]["in_forClient"].each {|x| puts x}




#params = {
#   "command" => "select nom,cid from Client;"
#   ,
#   "parameters"=> []
#}

#sql = "#{urlp}/query/projets/sql/select nom,CID from Client"
#puts "Q=#{sql}\n========="
#rsp = nil
#begin
#   response = RestClient.get(URI::encode(sql))   #,params)
#   puts "response=#{response.code}"
#   rsp = JSON.parse(response.body)
#   puts "body\n=====#{rsp['result']}\n====="
#rescue => e
#   puts e
#   exit 1
#end
#rsp["result"].each {|x|
#      puts "nom=" + x["nom"] + "\t\tid=" + x["CID"].to_s
#} 
#p rsp["result"].map {|x| [x["nom"],x["CID"]]}
#p "CID=3 nom=" + rsp["result"].find {|x| x["CID"]==3}["nom"]