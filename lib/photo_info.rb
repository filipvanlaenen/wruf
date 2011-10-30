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

require 'digest/sha1'

#
# Class holding the all information about a photo.
#
class PhotoInfo

	attr_accessor :height, :title, :url, :width

	def download_photo(target_dir)
		uri = URI.parse(@url)
		Net::HTTP.start(uri.host) do |http|
			resp = http.get(uri.path) 
			open(File.join(target_dir, file_name), "wb") do |file|
				file.write(resp.body)
		   	end
		end	
	end

	def create_file_name
		base = Digest.hexencode(Digest::SHA1.digest(@url))
		extension = /.*\.([^\.]*)$/.match(@url)[1]
		return "#{base}.#{extension}"
	end

	def file_name
		if (@file_name == nil)
			@file_name = create_file_name
		end
		return @file_name
	end

end