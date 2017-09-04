
#$LOAD_PATH.unshift ".lib"

@project_name        = 'ORest'
@lib_dir             = 'lib'
@ruby_script_dir     = 'src/ruby'
@ruby_test_dir       = 'src/test/ruby'
@ruby_bin_dir        = 'bin'

JRUBY_COMPLETE = "vendor/jruby-complete-9.1.12.0.jar"
jars = FileList["#{@lib_dir}/**/*.jar"].join(':')
GEM_PATH="vendor/bundle"
#JRUBY = "java -classpath .:#{JRUBY_COMPLETE} org.jruby.Main "
LOCALGEMS = "GEM_HOME=#{GEM_PATH} GEM_PATH=#{GEM_PATH} "
JRUBY = "/usr/local/jruby/bin/jruby  "


#import 'java.rake'

# ------ Ruby testing
require 'rake/testtask'
Rake::TestTask.new do |task|
  task.libs << [@ruby_script_dir]
  task.test_files = FileList["#{@ruby_test_dir}/Test_*.rb"]
  task.pattern = 'Test_*.rb'
   task.verbose = true
end

# ----- Ruby tasks
namespace :ruby do
   task :run do
     arg =  "#{@ruby_bin_dir}/application_bootstrap"
     libs = "#{@ruby_script_dir}:#{@ruby_bin_dir}:#{@lib_dir}"
     sh %!#{LOCALGEMS} #{JRUBY} -I #{libs} #{arg}!
#     sh "/usr/local/jruby/bin/jruby -I #{libs} #{arg}"
   end
   # Run with nailgun
   task :rung do
     arg =  "#{@ruby_bin_dir}/application_bootstrap"
     libs = "#{@ruby_script_dir}:#{@ruby_bin_dir}:#{@lib_dir}"
     sh %!#{LOCALGEMS} #{JRUBY} --ng -I #{libs} #{arg}!
#     sh "/usr/local/jruby/bin/jruby --ng -I #{libs} #{arg}"
   end

end

 
# ----- Clean
require 'rake/clean'
    CLEAN << @java_build_dir

task :default => "ruby:rung"
