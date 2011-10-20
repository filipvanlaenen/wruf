#
# Wallpaper Rotator Using Flickr (WRUF)
# Copyright © 2011 Filip van Laenen <f.a.vanlaenen@ieee.org>
#
# This file is part of WRUF.
#
# WRUF is free software: you can redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# WRUF is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You can find a copy of the GNU General Public License in /doc/gpl.txt
#

#
# Rake file, to run the unit tests, test coverage, static code analysis and mutation testing.
#

$:.unshift File.join(File.dirname(__FILE__), 'lib')

task :default => [:test]

task :all => [:test, :rcov, :roodi, :heckle]

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
			t.rcov_opts << '-x "\A/usr/local/lib,\A/var/lib/gems"'
			t.rcov_opts << '--sort coverage'
			t.rcov_opts << '--sort-reverse'
			t.rcov_opts << '--text-report'
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

# Heckle

namespace :heckle do
	desc "Deleting all heckle log files from previous run."
	task(:clean) { system ("rm qa/heckle-*.log") }
end

desc "Mutation testing with Heckle"
task :heckle => "heckle:clean" do
	Heckle.new('FlickrSearcher').defined_in('flickr_searcher.rb') \
								.tested_by('flickr_searcher_unit_test.rb') \
								.skip('download_photo', 'find_next_photo_info', 'get_infoset') \
								.heckle
	Heckle.new('PhotoDecorator').defined_in('photo_decorator.rb') \
								.tested_by('photo_decorator_unit_test.rb') \
								.skip('convert_svg_to_jpg', 'create_svg', 'decorate', 'save_svg_to_file', 'write_svg_to_file') \
								.heckle
	Heckle.new('PhotoHistory').defined_in('photo_history.rb') \
	                          .tested_by('photo_history_unit_test.rb') \
	                          .skip('record') \
	                          .heckle
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

# Heckle class

class Heckle

	def initialize(classname)
		@classname = classname
		@exclude_methods = nil
	end
	
	def defined_in(codefile)
		@codefile = codefile
		return self
	end
	
	def tested_by(testfile)
		@testfile = "test/#{testfile}"
		return self
	end
	
	def skip(*method_names)
		if (@exclude_methods == nil)
			@exclude_methods = []
		end
		@exclude_methods = @exclude_methods + method_names
		return self
	end

	def heckle(include_methods = nil)
		require @codefile
		klass = Object.const_get("#{@classname}")
		if (include_methods == nil)
			methods = klass.instance_methods.sort - klass.superclass.instance_methods
		else
			methods = include_methods
		end
		if (@exclude_methods != nil)
			methods = methods.reject { | method | @exclude_methods.include?(method.to_s) }
		end
		puts "Doing mutation testing on #{methods.length} method(s) of #{@classname} against #{@testfile}:"
		number_of_mutations = 0
		i = 0
		methods.each do |method|
			i += 1
			puts " o #{@classname}##{method} [#{i}/#{methods.length}]"
			heckle_log = "qa/heckle-#{@classname}##{method}.log"
			cmd = "heckle #{@classname} #{method} -t #{@testfile} -F > #{heckle_log}"
			system(cmd)
			result = read_file(heckle_log)
			while (result.include?("Mutation caused a syntax error:")) do
				system(cmd)
				result = read_file(heckle_log)
				puts "   -> Mutation caused a syntax error -- re-running this task."
			end
			if (!result.include?("All heckling was thwarted! YAY!!!"))
				raise "#{result}\nRe-run this specific test case using '#{cmd}'."
			elsif (result =~ /loaded with (\d+) possible mutations/)
				number_of_mutations += $1.to_i
			end
		end
		puts "Checked #{number_of_mutations} mutations, and no issues were found in #{@classname}."
	end

end