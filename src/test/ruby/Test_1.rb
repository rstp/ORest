#test_properties
#gem 'minitest'
require 'minitest/autorun'
require 'minitest/hooks/default'
require 'restinit'

describe "General tests" do
  before (:all) do
      @RO = RESTorient.new
  end


      it "returns a Hi 5" do
         @RO.getHi5('Hi5').must_equal 'Hi5'
      end
end
