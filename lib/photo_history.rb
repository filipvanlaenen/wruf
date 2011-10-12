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
# A class keeping track of the photo history.
#

require 'photo_history'

class PhotoHistory

	def initialize(file_name, urls)
		@urls = urls
		@file_name = file_name
	end
	
	def include?(url)
		return @urls.include?(url)
	end
	
	def record(url)
		file = File.open(@file_name, 'a')
		file.puts(url)
		file.close
	end

	def self.load_history(file_name)
		lines = []
		if (File.exist?(file_name))
			file = File.open(file_name, 'r')
			line = file.gets
			while (line)
				lines << line.strip
				line = file.gets
			end
			file.close		
		end
		return PhotoHistory.new(file_name, lines)
	end

end