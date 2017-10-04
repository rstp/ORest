#test_properties
#gem 'minitest'
require 'minitest/autorun'
require 'minitest/hooks/default'
require 'OrientDB'

describe "General tests" do
  before (:all) do
      @DB = OrientDB.new
#      @DB.makeconnection('test_projets', 'admin', 'admin', true))
  end


      it "creates the database" do
#        "5".must_equal "4"
        @DB.createdb( 'test_projets' ).must_equal false
      end
      
#      it "creates client class" do
#        client = @DB.makeconnection( 'test_projets', 'admin', 'admin', true )
#        unless client.class_exists? "Client"
#          client.create_class("Client").must_equal true
#        end
#      end
end
