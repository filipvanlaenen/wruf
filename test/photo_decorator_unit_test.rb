#
# Unit tests on PhotoDecorator.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'photo_decorator'
require 'test/unit'

class PhotoDecoratorUnitTest < Test::Unit::TestCase
	
	def setup
		@decorator = PhotoDecorator.new([1280, 800])
	end
	
	def assert_get_png_file_name_from_svg_file_name_correct(svg_file_name, expected_png_file_name)
		actual_png_file_name = @decorator.get_png_file_name_from_svg_file_name(svg_file_name)
		assert_equal expected_png_file_name, actual_png_file_name
	end
		
	def test_png_for_svg_at_the_end
		assert_get_png_file_name_from_svg_file_name_correct('foo.svg', 'foo.png')
	end

	def test_png_for_svg_in_the_middle
		assert_get_png_file_name_from_svg_file_name_correct('foo.svg.bar.svg', 'foo.svg.bar.png')
	end

	def assert_get_svg_file_name_from_photo_file_name_correct(photo_file_name, expected_svg_file_name)
		actual_svg_file_name = @decorator.get_svg_file_name_from_photo_file_name(photo_file_name)
		assert_equal expected_svg_file_name, actual_svg_file_name
	end
	
	def test_svg_for_jpg_at_the_end
		assert_get_svg_file_name_from_photo_file_name_correct('foo.jpg', 'foo.svg')
	end
	
	def test_svg_for_png_at_the_end
		assert_get_svg_file_name_from_photo_file_name_correct('foo.png', 'foo.svg')
	end
	
	def assert_svg_document(photo_file_name, photo_info, photo_url, expected_svg)
		actual_svg = @decorator.create_svg_file(photo_file_name, photo_info, photo_url)
		assert_equal expected_svg.strip, actual_svg.strip
	end
	
	def test_svg
		photo_info = REXML::Document.new('<photo id="41942696" owner="23548413@N00" secret="ac7de727a7" server="28" farm="1" title="Holding on" ispublic="1" isfriend="0" isfamily="0" o_width="1023" o_height="628" originalsecret="ac7de727a7" originalformat="jpg" />').elements['photo']
		expected_svg = <<EOF
<?xml version='1.0' standalone='no'?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg version='1.1' height='800' xmlns:xlink='http://www.w3.org/1999/xlink' width='1280' xmlns='http://www.w3.org/2000/svg'><image xlink:href='foo.jpg' x='0' y='0' height='628' width='1023'/></svg>
EOF
		assert_svg_document('foo.jpg', photo_info, 'http://bar.com/foo.jpg', expected_svg)
	end
end
