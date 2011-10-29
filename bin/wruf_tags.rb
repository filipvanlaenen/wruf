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
# Starts an interactive dialogue with the user to manage the tags.
# The directory from which WRUF will be run, must be the first parameter of the script.
#

require 'yaml'
require 'wruf_settings'

local_wruf_dir = File.expand_path(ARGV[0])
settings_yaml = File.join(local_wruf_dir, 'wruf.yaml')
settings = WrufSettings.load(settings_yaml)

def display_help
	puts 'Use the following commands to manage the tags:'
	puts '  add tag      add a tag'
	puts '  delete tag   delete a tag'
	puts '  help         display the list of commands'
	puts 'or enter an empty line when you\'re done.'
	puts
end

def display_tags(settings)
	if (settings.tags.empty?)
		tags_set = '<none>'
	else
		tags_set = settings.tags.join(', ')
	end
	puts "Current set of tags: #{tags_set}."
end

def read_input
	print '> '
	return STDIN.readline.chomp
end

display_help
display_tags(settings)
input = read_input

while (!input.empty?)
	input.strip!
	if (input == 'help')
		display_help
	elsif (/^add\s+\w+$/.match(input))
		tag = /^add\s+(\w+)$/.match(input)[1]
		if (settings.tags.include?(tag))
			puts "#{tag} is already in the set of tags."
		else
			settings.tags << tag
			puts "Added #{tag} to the set of tags."
		end
	elsif (/^delete\s+\w+$/.match(input))
		tag = /^delete\s+(\w+)$/.match(input)[1]
		if (settings.tags.include?(tag))
			settings.tags.delete(tag)
			puts "Removed #{tag} from the set of tags."
		else
			puts "#{tag} isn't in the set of tags."
		end
	else
		puts "Could not parse the command '#{input}'."
		display_help
	end
	display_tags(settings)
	input = read_input
end

display_tags(settings)

open(settings_yaml, "w") { |file|
	file.write(settings.to_yaml)
}