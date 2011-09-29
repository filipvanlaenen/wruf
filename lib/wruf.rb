require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

FlickRestServicesUri = 'http://api.flickr.com/services/rest/'
SearchMethod = 'flickr.photos.search'
ApiKey = '22d606ee88b821d73258bd42859af76a'

def search_new_pic(tags)
	
	uri = URI.parse(FlickRestServicesUri)

	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.path)
	request.set_form_data({'method' => SearchMethod,
		                   'api_key' => ApiKey,
		                   'extras' => 'o_dims,original_format',
		                   'format' => 'json',
		                   'media' => 'photos',
		                   'safe_search' => '1',
		                   'sort' => 'interestingness-desc',
		                   'tags' => tags.join(','),
		                   'tag_mode' => 'any'})

	request = Net::HTTP::Get.new( uri.path+ '?' + request.body )

	response = http.request(request)

	case response
	when Net::HTTPSuccess, Net::HTTPRedirection
		puts response.body
		puts JSON.parse(response.body)
	else
		puts "Error"
	end		
end

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

pic_info = search_new_pic(['green', 'blue'])
pic_filename = download_pic(pic_info)
decorate_pic(pic_filename, pic_info)
set_pic_as_background(pic_filename)
log_pic(pic_info)