require 'orientdb4r'
require 'json'
#require 'OrientDB'

name='test_projets'

client = Orientdb4r.client :host => 'airstp', :port => 2480, :ssl => false

#client.create_database :database=>name, :user=>'root', :password=>'root'#, :storage=>:plocal

client.database_exists? :database=>name, :user=>'admin', :password=>'admin'
