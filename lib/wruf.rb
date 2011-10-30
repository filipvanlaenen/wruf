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
require 'wruf_settings'

#
# Main class for WRUF.
#
class WRUF

	include Log4r

	attr_accessor :dir
	attr_reader :settings

	SecondsPerHour = 3600
	RotationMarginInSeconds = 300

	LocalPhotoFileName = 'local_copy.jpg'
	HistoryFileName = 'history.txt'
	LogFileName = 'wruf.log'
	YamlFileName = 'wruf.yaml'
	
	def initialize
		@settings = WrufSettings.new
	end	
	
	def load_settings(file_name)
		@settings = WrufSettings.load(file_name)
	end
			
	def self.load(dir)
		wruf = WRUF.new
		wruf.dir = File.expand_path(dir)
		wruf.load_settings(File.join(wruf.dir, YamlFileName))
		return wruf
	end

	def get_ubuntu_release
		return %x[lsb_release -rs]
	end
	
	def ubuntu_release_compare(a, b)
		as = a.split('.')
		bs = b.split('.')
		if (as.first.to_i == bs.first.to_i)
			return as.last.to_i <=> bs.last.to_i
		else
			return as.first.to_i <=> bs.first.to_i
		end
	end

	def set_pic_as_background(pic_filename)
		ubuntu_release = get_ubuntu_release
		if (ubuntu_release_compare(ubuntu_release, '11.10') < 0)
			system "gconftool-2 -t string --set /desktop/gnome/background/picture_filename #{pic_filename}"
			system 'gconftool-2 -t string --set /desktop/gnome/background/picture_options "centered"'
		else
			system "gsettings set org.gnome.desktop.background picture-uri 'file://#{pic_filename}'"
			system 'gsettings set org.gnome.desktop.background picture-options \'centered\''
		end
	end
	
	def history_file_name
		return File.join(@dir, HistoryFileName)
	end
	
	def too_few_seconds_since_last_rotation?(seconds_since_last_rotation)
		return seconds_since_last_rotation < @settings.hours * SecondsPerHour - RotationMarginInSeconds
	end
	
	def too_recent_since_last_rotation?
		@log.debug("Checking the history file at #{history_file_name} to find out when the wallpaper has been rotated the last time.")
		if (!File.exist?(history_file_name))
			return false
		end
		seconds_since_last_rotation = Time.now - File.mtime(history_file_name)
		@log.debug("Wallpaper has been rotated #{seconds_since_last_rotation} seconds ago.")
		return too_few_seconds_since_last_rotation?(seconds_since_last_rotation)
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
		begin
			history = PhotoHistory.load_history(history_file_name)
			searcher = FlickrSearcher.new(@settings.dimensions, @settings.tolerance, @settings.tags)
			photo_info = searcher.find_next_photo_info(history)
			photo_info.download_photo(File.join(@dir, 'cache'))
			photo_decorator = PhotoDecorator.new(@settings)
			decorated_photo_file_name = photo_decorator.decorate(photo_info, File.join(@dir, 'cache'))
			set_pic_as_background(decorated_photo_file_name)
			@log.info("Used the photo at #{photo_info.url} as the new wallpaper.")
			history.record(photo_info.url)
		rescue Exception => e
			@log.fatal(e)
			exit
		end
	end

end