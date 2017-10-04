
#$LOAD_PATH.unshift ".lib"

@project_name        = 'ORest'
@lib_dir             = 'lib'
@ruby_script_dir     = 'src/ruby'
@ruby_test_dir       = 'src/test/ruby'
@ruby_bin_dir        = 'bin'

JRUBY_COMPLETE = "vendor/jruby-complete-9.1.12.0.jar"
jars = FileList["#{@lib_dir}/**/*.jar"].join(':')
GEM_PATH="vendor/bundle/jruby/2.3.0"
GEM_HOME="vendor/gem_home"
#JRUBY = "java -classpath .:#{JRUBY_COMPLETE} org.jruby.Main "
APP_GEMS = "GEM_PATH=#{GEM_PATH} "
JRUBY = "/usr/local/jruby/bin/jruby  "
LOCALGEMS = "GEM_HOME=#{GEM_HOME} GEM_PATH=#{GEM_PATH} "


#import 'java.rake'

# ------ RUBY TESTING
require 'rake/testtask'
Rake::TestTask.new do |task|
  task.libs << [@ruby_script_dir]
  task.test_files = FileList["#{@ruby_test_dir}/Test_*.rb"]
  task.pattern = 'Test_*.rb'
  task.verbose = true
end

# ----- RUBY TASKS
namespace :ruby do
   task :run do
     arg =  "#{@ruby_bin_dir}/application_bootstrap"
     libs = "#{@ruby_script_dir}:#{@ruby_bin_dir}:#{@lib_dir}"
     sh %!#{APP_GEMS} #{JRUBY}  -I #{libs} #{arg}!
   end
   # Run with nailgun
   task :rung do
     arg =  "#{@ruby_bin_dir}/application_bootstrap"
     libs = "#{@ruby_script_dir}:#{@ruby_bin_dir}:#{@lib_dir}"
     sh %!#{APP_GEMS} #{JRUBY}  --ng  -I #{libs} #{arg}!
   end

   # Run  odb script
   task :rodb do
     arg =  "#{@ruby_script_dir}/odb.rb"
     libs = "#{@ruby_script_dir}:#{@ruby_bin_dir}:#{@lib_dir}"
     sh %!#{APP_GEMS} #{JRUBY}  --ng  -I #{libs} #{arg}!
     
   end
end

# ------ PROJECT SETUP
namespace :setup do
   desc "1-Install bundler and warbler"
   task :bundler do
      sh %!#{JRUBY} -S gem install -i #{GEM_HOME} --no-rdoc --no-ri bundler warbler!
   end

   desc "2-Install the gems"
   task :gems do
      sh %!#{LOCALGEMS} #{JRUBY} -S bundle install --path=#{GEM_PATH} --binstubs !
   end

   desc "3-Package gems"
   task :pack do
      sh %!#{LOCALGEMS} #{JRUBY} -S bundle package!
   end

   desc "4-Create stand_alone Jar"
   task :jar do
      sh %!#{LOCALGEMS} #{JRUBY} -S warble!
   end

end #setup
 
# ----- Clean
require 'rake/clean'
    CLEAN << @java_build_dir

task :default => "ruby:rung"  #rung"
