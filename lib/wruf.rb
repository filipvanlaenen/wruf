#
# Wallpaper Rotator Using Flickr (WRUF)
# Copyright © 2011 Filip van Laenen <f.a.vanlaenen@ieee.org>
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You can find a copy of the GNU General Public License in /doc/gpl.txt
#

require 'flickr_searcher'
require 'photo_decorator'
require 'photo_history'
require 'yaml'

#
# Main class for WRUF.
#
class WRUF

	attr_accessor :dimensions, :hours, :tolerance
	attr_writer :dir

	LocalPhotoFileName = 'local_copy.jpg'
	HistoryFileName = 'history.txt'
	YamlFileName = 'wruf.yaml'
	
	def self.load(dir)
		expanded_dir = File.expand_path(dir)
		file_name = File.join(expanded_dir, YamlFileName)
		wruf = YAML::load(read_file(file_name))
		wruf.dir = expanded_dir
		return wruf
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

	def set_pic_as_background(pic_filename)
		system "gconftool-2 -t string --set /desktop/gnome/background/picture_filename #{pic_filename}"
		system 'gconftool-2 -t string --set /desktop/gnome/background/picture_options "centered"'
	end
	
	def history_file_name
		return File.join(@dir, HistoryFileName)
	end
	
	def too_recent_since_last_rotation?
		if (!File.exist?(history_file_name))
			return false
		end
		seconds_since_last_rotation = Time.now - File.mtime(history_file_name)
		return (seconds_since_last_rotation < @hours*60*60)
	end

	def run
		if (too_recent_since_last_rotation?)
			exit
		end
		history = PhotoHistory.load_history(history_file_name)
		searcher = FlickrSearcher.new(@dimensions, @tolerance, @tags)
		photo_info = searcher.find_next_photo_info(history)
		photo_url = searcher.get_photo_url(photo_info)
		searcher.download_photo(photo_url, File.join(@dir, LocalPhotoFileName))
		photo_decorator = PhotoDecorator.new(@dimensions)
		decorated_photo_file_name = photo_decorator.decorate(File.join(@dir, LocalPhotoFileName), photo_info, photo_url)
		set_pic_as_background(decorated_photo_file_name)
		history.record(photo_url)
	end

end