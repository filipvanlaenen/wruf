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

require 'flickr_searcher'
require 'rexml/document'
require 'test/unit'

#
# Unit tests on FlickrSearcher.
#
class FlickrSearcherUnitTest < Test::Unit::TestCase

	SampleFlickrResponseString = <<EOF
<?xml version="1.0" encoding="utf-8" ?>
<rsp stat="ok">
   <photos page="1" pages="103023" perpage="100" total="10302247">
	<photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="ac7de727a7" originalformat="jpg" />
	<photo id="91957795" owner="86685058@N00" secret="5a27611762" server="42" farm="1" title="Lady Lula's Bright Eyed Stare" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6191592935" owner="21207178@N07" secret="812fde0cce" server="6180" farm="7" title="Backlighted Web" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6163225374" owner="21207178@N07" secret="3aa6e41d07" server="6168" farm="7" title="Ferris Wheel at Night" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6145252600" owner="29609591@N08" secret="306ae87341" server="6088" farm="7" title="Ardnamurchan Lighthouse" ispublic="1" isfriend="0" isfamily="0" o_width="2000" o_height="668" originalsecret="0d92215993" originalformat="jpg" />
	<photo id="6120848461" owner="29609591@N08" secret="170984e444" server="6209" farm="7" title="Loch of Lowes Tester 5D Mark II Mark II" ispublic="1" isfriend="0" isfamily="0" o_width="3000" o_height="1000" originalsecret="74e4af587a" originalformat="jpg" />
	<photo id="6106109890" owner="37642573@N06" secret="00bdfa18ea" server="6089" farm="7" title="Now I'm to 42, Happy birthday for me" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6096924690" owner="47843999@N02" secret="baf01f9079" server="6081" farm="7" title="Mountain Shed (HDR) - Source Photos Available!!!" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6072830085" owner="8407953@N03" secret="1e0479ce7a" server="6202" farm="7" title="Path To Light" ispublic="1" isfriend="0" isfamily="0" o_width="2024" o_height="3702" originalsecret="ec0aa8edc7" originalformat="jpg" />
	<photo id="6072738710" owner="38181284@N06" secret="522ec2a319" server="6210" farm="7" title="Dubrovnik Moonlight (Explored)" ispublic="1" isfriend="0" isfamily="0" o_width="3976" o_height="2720" originalsecret="59cff4fe40" originalformat="jpg" />
	<photo id="6049906927" owner="72179079@N00" secret="a853b3460f" server="6083" farm="7" title="All inclusive, swimmers..:)))" ispublic="1" isfriend="0" isfamily="0" o_width="1030" o_height="1030" originalsecret="2d85d65f54" originalformat="jpg" />
	<photo id="6048288207" owner="53760536@N07" secret="9037d9a51d" server="6068" farm="7" title="Valley Stars" ispublic="1" isfriend="0" isfamily="0" />
	<photo id="6045494525" owner="8407953@N03" secret="1d6706b14a" server="6197" farm="7" title="Color Flash II" ispublic="1" isfriend="0" isfamily="0" o_width="1280" o_height="800" originalsecret="7058d4bfdc" originalformat="jpg" />
	<photo id="6042343394" owner="21207178@N07" secret="0ea3b9830c" server="6193" farm="7" title="I take the Poppy to the left" ispublic="1" isfriend="0" isfamily="0" />
   </photos>	
</rsp>	
EOF
	SampleFlickrResponse = REXML::Document.new(SampleFlickrResponseString)
	SampleFlickrPhoto1Id = '6072738710'
	SampleFlickrPhoto1Url = 'http://farm7.static.flickr.com/6210/6072738710_59cff4fe40_o.jpg'
	SampleFlickrPhoto1Info = '<photo id="6072738710" owner="38181284@N06" secret="522ec2a319" server="6210" farm="7" title="Dubrovnik Moonlight (Explored)" ispublic="1" isfriend="0" isfamily="0" o_width="3976" o_height="2720" originalsecret="59cff4fe40" originalformat="jpg" />'
	SampleFlickrPhoto2Id = '6045494525'
	SampleFlickrPhoto2Url = 'http://farm7.static.flickr.com/6197/6045494525_7058d4bfdc_o.jpg'
	SampleFlickrPhoto3Info = '<photo id="91957795" owner="86685058@N00" secret="5a27611762" server="42" farm="1" title="Lady Lula\'s Bright Eyed Stare" ispublic="1" isfriend="0" isfamily="0" />'
	SampleFlickrPhoto3Url = 'http://farm1.static.flickr.com/42/91957795_5a27611762_o.jpg'
	SampleFlickrPhotoWithDifferentFormatInfo = '<photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="ac7de727a7" originalformat="png" />'
	SampleFlickrPhotoWithDifferentOriginalSecretInfo = '<photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="5a27611762" originalformat="jpg" />'
	SampleFlickrPhotoWithDifferentFormatUrl = 'http://farm1.static.flickr.com/28/41942696_ac7de727a7_o.png'
	SampleFlickrPhotoWithDifferentOriginalSecretUrl = 'http://farm1.static.flickr.com/28/41942696_5a27611762_o.jpg'
	HistoryFileName = 'history.txt'

	def setup
		@searcher = FlickrSearcher.new([1280, 800], 0.2, ['foo', 'bar'])
	end
	
	def test_should_get_first_photo_info_when_no_history
		history = PhotoHistory.new(HistoryFileName, [])
		photo_info = @searcher.get_photo_info(SampleFlickrResponse, history)
		assert_equal SampleFlickrPhoto1Id, photo_info.attributes['id']
	end
	
	def test_should_get_second_photo_info_if_first_in_history
		history = PhotoHistory.new(HistoryFileName, [SampleFlickrPhoto1Url])
		photo_info = @searcher.get_photo_info(SampleFlickrResponse, history)
		assert_equal SampleFlickrPhoto2Id, photo_info.attributes['id']
	end

	def test_return_nil_if_all_photos_in_history
		history = PhotoHistory.new(HistoryFileName, [SampleFlickrPhoto1Url, SampleFlickrPhoto2Url])
		assert_nil @searcher.get_photo_info(SampleFlickrResponse, history)
	end

	def test_compose_url_from_photo_info
		photo_info = REXML::Document.new(SampleFlickrPhoto1Info).elements["photo"]
		assert_equal SampleFlickrPhoto1Url, @searcher.get_photo_url(photo_info)
	end

	def test_compose_url_from_photo_info_lacking_original_info
		photo_info = REXML::Document.new(SampleFlickrPhoto3Info).elements["photo"]
		assert_equal SampleFlickrPhoto3Url, @searcher.get_photo_url(photo_info)
	end
	
	def test_compose_url_from_photo_info_with_different_format
		photo_info = REXML::Document.new(SampleFlickrPhotoWithDifferentFormatInfo).elements["photo"]
		assert_equal SampleFlickrPhotoWithDifferentFormatUrl, @searcher.get_photo_url(photo_info)
	end
	
	def test_compose_url_from_photo_info_with_different_original_secret
		photo_info = REXML::Document.new(SampleFlickrPhotoWithDifferentOriginalSecretInfo).elements["photo"]
		assert_equal SampleFlickrPhotoWithDifferentOriginalSecretUrl, @searcher.get_photo_url(photo_info)
	end
end