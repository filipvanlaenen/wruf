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
# Class holding the settings for WRUF.
#
class WrufSettings

	attr_accessor :dimensions, :holidays_options, :hours, :tolerance
	attr_reader :tags

	def initialize
		@tags = []
	end
	
	def self.load(file_name)
		YAML::safe_load(read_file(file_name), permitted_classes: [WrufSettings, Symbol])
	end
	
	def self.read_file(file_name)
		file = File.open(file_name, 'r')
		content = ""
		line = file.gets
		while (line)
			content += line
			line = file.gets
		end
		file.close		
		return content
	end		
	

end
