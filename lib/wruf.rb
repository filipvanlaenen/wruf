#
# Script to start WRUF.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'flickr_searcher'

LocalPhotoFileName = File.join(File.expand_path(File.dirname(__FILE__)), 'local_copy.jpg') 

def decorate_pic(pic_filename, pic_info)
	# Add the title of the pic
	# Add the name of the author
	# Add the source URL of the pic
	# Add the calendar based on today's date
end

def set_pic_as_background(pic_filename)
	system "gconftool-2 -t string --set /desktop/gnome/background/picture_filename #{pic_filename}"
	system 'gconftool-2 -t string --set /desktop/gnome/background/picture_options "centered"'
end

def log_pic(pic_info)
end

searcher = FlickrSearcher.new(['green', 'blue', 'fractal', 'astronomy'])
photo_info = searcher.find_next_photo_info
photo_url = searcher.get_photo_url(photo_info)
searcher.download_photo(photo_url, LocalPhotoFileName)
set_pic_as_background(LocalPhotoFileName)