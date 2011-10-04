#
# Script to start WRUF.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'flickr_searcher'
require 'photo_decorator'

LocalPhotoFileName = File.join(File.expand_path(File.dirname(__FILE__)), 'local_copy.jpg') 

def set_pic_as_background(pic_filename)
	system "gconftool-2 -t string --set /desktop/gnome/background/picture_filename #{pic_filename}"
	system 'gconftool-2 -t string --set /desktop/gnome/background/picture_options "centered"'
end

searcher = FlickrSearcher.new([1280, 800], 0.2, ['green', 'blue', 'fractal', 'astronomy'])
photo_info = searcher.find_next_photo_info
photo_url = searcher.get_photo_url(photo_info)
searcher.download_photo(photo_url, LocalPhotoFileName)
photo_decorator = PhotoDecorator.new([1280, 800])
decorated_photo_file_name = photo_decorator.decorate(LocalPhotoFileName, photo_info, photo_url)
set_pic_as_background(decorated_photo_file_name)