#
# A class searching Flickr.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'net/http'
require 'uri'
require 'rexml/document'

class FlickrSearcher

	FlickRestServicesUri = 'http://api.flickr.com/services/rest/'
	SearchMethod = 'flickr.photos.search'
	ApiKey = '22d606ee88b821d73258bd42859af76a'

	def initialize(tags)
		@tags = tags
	end

	def get_infoset(tags)
		uri = URI.parse(FlickRestServicesUri)

		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.path)
		request.set_form_data({'method' => SearchMethod,
				               'api_key' => ApiKey,
				               'extras' => 'o_dims,original_format',
				               'format' => 'rest',
				               'media' => 'photos',
				               'safe_search' => '1',
				               'sort' => 'interestingness-desc',
				               'tags' => tags.join(','),
				               'tag_mode' => 'any'})

		request = Net::HTTP::Get.new( uri.path+ '?' + request.body )

		response = http.request(request)

		case response
		when Net::HTTPSuccess, Net::HTTPRedirection
			return REXML::Document.new(response.body)
		else
			raise "An error occured while trying to search Flickr"
		end		
	end
	
	def get_photo_info(info_set)
		return info_set.elements["rsp/photos/photo"]
	end
	
	def find_next_photo_info
		info_set = get_infoset(@tags)
		return get_photo_info(info_set)
	end
	
	def get_photo_url(photo_info)
		id = photo_info.attributes['id']
		farm_id = photo_info.attributes['farm']
		server_id = photo_info.attributes['server']
		secret = photo_info.attributes['originalsecret']
		if (secret == nil)
			secret = photo_info.attributes['secret']
		end
		format = photo_info.attributes['originalformat']
		if (format == nil)
			format = 'jpg'
		end
		return "http://farm#{farm_id}.static.flickr.com/#{server_id}/#{id}_#{secret}_o.#{format}"
	end
	
	def download_photo(photo_url, target)
		uri = URI.parse(photo_url)
		Net::HTTP.start(uri.host) { |http|
			resp = http.get(uri.path) 
			open(target, "wb") { |file|
				file.write(resp.body)
		   	}
		}	
	end

end