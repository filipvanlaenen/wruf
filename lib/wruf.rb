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
require 'rubygems'
require 'log4r'
require 'photo_decorator'
require 'photo_history'
require 'yaml'

#
# Main class for WRUF.
#
class WRUF

	include Log4r

	attr_accessor :dimensions, :hours, :tolerance
	attr_reader :tags
	attr_writer :dir

	LocalPhotoFileName = 'local_copy.jpg'
	HistoryFileName = 'history.txt'
	LogFileName = 'wruf.log'
	YamlFileName = 'wruf.yaml'
	
	def initialize
		@tags = []
	end
	
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
		@log.debug("Checking the history file at #{history_file_name} to find out when the wallpaper has been rotated the last time.")
		if (!File.exist?(history_file_name))
			return false
		end
		seconds_since_last_rotation = Time.now - File.mtime(history_file_name)
		@log.debug("Wallpaper has been rotated #{seconds_since_last_rotation} seconds ago.")
		return (seconds_since_last_rotation < @hours*60*60)
	end
	
	def initialize_logging
		@log = Logger.new('log')
		@log.level = INFO
		file_outputter = FileOutputter.new('fileOutputter', :filename =>  File.join(@dir, LogFileName), :trunc => false)
		pattern_formatter = PatternFormatter.new(:pattern => "%d %l: %M")
		file_outputter.formatter = pattern_formatter
		@log.outputters = file_outputter
	end

	def run(override_time = false)
	    initialize_logging
	    if (override_time)
	    	@log.info("Not checking when the wallpaper was rotated for the last time; user doesn't like the current wallpaper.")
	    elsif (too_recent_since_last_rotation?)
			@log.debug("Wallpaper has been rotated less than #{@hours} hours ago; won't rotate it again now.")
			exit
		end
		history = PhotoHistory.load_history(history_file_name)
		searcher = FlickrSearcher.new(@dimensions, @tolerance, @tags)
		photo_info = searcher.find_next_photo_info(history)
		photo_url = searcher.get_photo_url(photo_info)
		@log.info("Going to use the photo at #{photo_url} as the new wallpaper.")
		photo_file_name = searcher.get_photo_file_name(photo_url)
		photo_path = File.join(File.join(@dir, 'cache'), photo_file_name)
		searcher.download_photo(photo_url, photo_path)
		photo_decorator = PhotoDecorator.new(@dimensions)
		decorated_photo_file_name = photo_decorator.decorate(photo_path, photo_info, photo_url)
		set_pic_as_background(decorated_photo_file_name)
		history.record(photo_url)
	end

end