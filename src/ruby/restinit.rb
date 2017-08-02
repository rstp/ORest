require 'orientdb4r'
require 'json'


class RESTorient
   def initialize
      @client = Orientdb4r.client :host => 'localhost',
         :port => 2480,
         :ssl => false
      @client.connect :database => 'projets',
         :user => 'admin', :password => 'admin'
   end

   def run
      response = @client.query "select CID,nom,addresse,tele from client"
      response.each do |r|
         puts "nom => #{r['nom']} addresse => #{r['addresse']}"
#         :tele => r["tele"] || "000"
      end

      @client.disconnect
   end

   def getHi5(hi)
      hi
   end
end
