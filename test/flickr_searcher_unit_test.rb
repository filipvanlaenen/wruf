#
# Unit tests on FlickrSearcher.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'flickr_searcher'
require 'rexml/document'
require 'test/unit'

class FlickrSearcherUnitTest < Test::Unit::TestCase

	SampleFlickrResponseString = <<EOF
<?xml version="1.0" encoding="utf-8" ?>
<rsp stat="ok">
   <photos page="1" pages="103023" perpage="100" total="10302247">
	  <photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="ac7de727a7" originalformat="jpg" />
	  <photo id="91957795" owner="86685058@N00" secret="5a27611762" server="42" farm="1" title="Lady Lula's Bright Eyed Stare" ispublic="1" isfriend="0" isfamily="0" />
   </photos>	
</rsp>	
EOF
	SampleFlickrResponse = REXML::Document.new(SampleFlickrResponseString)
	SampleFlickrPhoto1Id = '41942696'
	SampleFlickrPhoto1Info = '<photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="ac7de727a7" originalformat="jpg" />'
	SampleFlickrPhoto2Info = '<photo id="91957795" owner="86685058@N00" secret="5a27611762" server="42" farm="1" title="Lady Lula\'s Bright Eyed Stare" ispublic="1" isfriend="0" isfamily="0" />'
	SampleFlickrPhoto1Url = 'http://farm1.static.flickr.com/28/41942696_ac7de727a7_o.jpg'
	SampleFlickrPhoto2Url = 'http://farm1.static.flickr.com/42/91957795_5a27611762_o.jpg'

	def setup
		@searcher = FlickrSearcher.new(['foo', 'bar'])
	end
	
	def test_should_get_first_photo_info
		photo_info = @searcher.get_photo_info(SampleFlickrResponse)
		assert_equal SampleFlickrPhoto1Id, photo_info.attributes['id']
	end
	
	def test_compose_url_from_photo_info
		photo_info = REXML::Document.new(SampleFlickrPhoto1Info).elements["photo"]
		assert_equal SampleFlickrPhoto1Url, @searcher.get_photo_url(photo_info)
	end

	def test_compose_url_from_photo_info_lacking_original_info
		photo_info = REXML::Document.new(SampleFlickrPhoto2Info).elements["photo"]
		assert_equal SampleFlickrPhoto2Url, @searcher.get_photo_url(photo_info)
	end
end