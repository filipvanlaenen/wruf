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

require 'photo_info'
require 'net/http'
require 'uri'
require 'rexml/document'

#
# A class searching Flickr.
#
class FlickrSearcher

	FlickRestServicesUri = 'http://api.flickr.com/services/rest/'
	SearchMethod = 'flickr.photos.search'
	ApiKey = '22d606ee88b821d73258bd42859af76a'

	def initialize(dims, tolerance, tags)
		@width = dims[0]
		@height = dims[1]
		@tolerance = tolerance
		@tags = tags
	end

	def get_infoset(tags, i)
		uri = URI.parse(FlickRestServicesUri)

		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.path)
		form_data = {'method' => SearchMethod,
			           'api_key' => ApiKey,
			           'extras' => 'o_dims,original_format',
			           'format' => 'rest',
			           'media' => 'photos',
			           'page' => i.to_s,
			           'safe_search' => '1',
			           'sort' => 'interestingness-desc',
			           'tag_mode' => 'any'}
		if (tags != nil)
			form_data['tags'] = tags.join(',')
		end
		request.set_form_data(form_data)

		request = Net::HTTP::Get.new(uri.path + '?' + request.body)

		response = http.request(request)

		case response
		when Net::HTTPSuccess, Net::HTTPRedirection
			return REXML::Document.new(response.body)
		else
			raise "An error occured while trying to search Flickr"
		end		
	end
	
	def get_photo_info(info_set, history)
		return info_set.get_elements("rsp/photos/photo") \
					   .select{|e| e.attributes["o_width"].to_i >= @width} \
					   .select{|e| e.attributes["o_height"].to_i >= @height} \
					   .select{|e| (e.attributes["o_height"].to_f / e.attributes["o_width"].to_f) / (@height.to_f / @width.to_f) < 1.to_f + @tolerance} \
					   .select{|e| (@height.to_f / @width.to_f) / (e.attributes["o_height"].to_f / e.attributes["o_width"].to_f) < 1.to_f + @tolerance} \
					   .reject{|e| history.include?(get_photo_url(e))} \
					   .first
	end
	
	def find_next_photo_info(history)
		i = 0
		xml_photo_info = nil
		while xml_photo_info == nil
			i = i + 1
			info_set = get_infoset(@tags, i)
			xml_photo_info = get_photo_info(info_set, history)
		end
		return convert_photo_info(xml_photo_info)
	end
	
	def convert_photo_info(xml_photo_info)
		photo_info = PhotoInfo.new
		photo_info.url = get_photo_url(xml_photo_info)
		photo_info.title = xml_photo_info.attributes['title']
		photo_info.width = xml_photo_info.attributes['o_width'].to_i
		photo_info.height = xml_photo_info.attributes['o_height'].to_i
		return photo_info
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
		
end