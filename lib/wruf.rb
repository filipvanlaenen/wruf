#
# Wallpaper Rotator Using Flickr (WRUF)
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'flickr_searcher'
require 'photo_decorator'
require 'photo_history'
require 'yaml'

class WRUF

	attr_accessor :dimensions, :hours, :tolerance

	LocalPhotoFileName = File.join(File.expand_path(File.dirname(__FILE__)), 'local_copy.jpg') 
	HistoryFileName = File.join(File.expand_path(File.dirname(__FILE__)), 'history.txt') 
	YamlFileName = 'wruf.yaml'
	
	def self.load(dir)
		file_name = File.join(dir, YamlFileName)
		return YAML::load(read_file(file_name))
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
	
	def too_recent_since_last_rotation?
		seconds_since_last_rotation = Time.now - File.mtime(HistoryFileName)
		return (seconds_since_last_rotation < @hours*60*60)
	end

	def run
		if (too_recent_since_last_rotation?)
			exit
		end
		history = PhotoHistory.load_history(HistoryFileName)
		searcher = FlickrSearcher.new(@dimensions, @tolerance, @tags)
		photo_info = searcher.find_next_photo_info(history)
		photo_url = searcher.get_photo_url(photo_info)
		searcher.download_photo(photo_url, LocalPhotoFileName)
		photo_decorator = PhotoDecorator.new(@dimensions)
		decorated_photo_file_name = photo_decorator.decorate(LocalPhotoFileName, photo_info, photo_url)
		set_pic_as_background(decorated_photo_file_name)
		history.record(photo_url)
	end

end