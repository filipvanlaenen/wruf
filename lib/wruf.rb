#
# Script to start WRUF.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'flickr_searcher'

def download_pic(pic_info)
	# Loading an original picture http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
end

def decorate_pic(pic_filename, pic_info)
	# Add the title of the pic
	# Add the name of the author
	# Add the source URL of the pic
	# Add the calendar based on today's date
end

def set_pic_as_background(pic_filename)
	# gconftool-2 -t str --set /desktop/gnome/background/picture_filename /path/pic.png
	# gconftool-2 -t str --set /desktop/gnome/background/picture_options "centered"
end

def log_pic(pic_info)
end

searcher = FlickrSearcher.new(['green', 'blue'])
photo_info = searcher.find_next_photo_info
