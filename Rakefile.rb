#
# Runs all the unit tests.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

$:.unshift File.join(File.dirname(__FILE__), 'lib')

task :default => [:test]

task :all => [:test, :rcov, :roodi]

# Test

%w[unit].each do | target |
	require 'rake/testtask'
	namespace :test do
		Rake::TestTask.new(target) do |t|
			t.libs << "test"
			t.test_files = FileList["test/*_#{target}_test.rb"]
			t.verbose = true
		end
	end
	task :test => "test:#{target}"
end

# RCov

namespace :rcov do
	desc "Delete aggregate coverage data."
	task(:clean) { rm_f "rcov.data" }
end

desc 'Aggregate code coverage for unit, functional and integration tests'
task :rcov => "rcov:clean"
%w[unit].each do |target|
	require 'rcov/rcovtask'
	namespace :rcov do
		Rcov::RcovTask.new(target) do |t|
			t.libs << "test"
			t.test_files = FileList["test/*_#{target}_test.rb"]
			t.output_dir = "qa/rcov/#{target}"
			t.verbose = true
			t.rcov_opts << '--aggregate rcov.data'
		end
	end
	task :rcov => "rcov:#{target}"
end

# Roodi

desc "Static code analysis with Roodi"
task :roodi do
	puts "Running static code analysis with Roodi:"
	roodifile = "qa/roodi.log"
	cmd = "roodi -config=roodi_config.yml lib/*.rb > #{roodifile}"
	system(cmd)
	result = read_file(roodifile)
	if (result.include?("Found 0 errors."))
		puts "No issues found."
	else
		raise result
	end
end

# Method to read the contents of a file

def read_file(filename)
	file = File.new(filename, "r")
	content = ""
	begin
		while (line = file.readline)
			content += line
		end
	rescue EOFError
		file.close
	end
	return content.strip
end