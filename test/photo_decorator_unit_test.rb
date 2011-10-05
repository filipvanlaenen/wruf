#
# Unit tests on PhotoDecorator.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'photo_decorator'
require 'test/unit'
require 'rexml/document'

class PhotoDecoratorUnitTest < Test::Unit::TestCase
	
	Width = 1280
	Height = 800
	Photo1Width = 2560
	Photo1Height = 1600
	Photo1Info = REXML::Document.new("<photo id=\"41942696\" owner=\"23548413@N00\" secret=\"ac7de727a7\" server=\"28\" farm=\"1\" title=\"Holding on\" ispublic=\"1\" isfriend=\"0\" isfamily=\"0\" o_width=\"#{Photo1Width}\" o_height=\"#{Photo1Height}\" originalsecret=\"ac7de727a7\" originalformat=\"jpg\" />").elements['photo']	
	Photo2Width = 1480
	Photo2Height = 800
	Photo2Info = REXML::Document.new("<photo id=\"41942696\" owner=\"23548413@N00\" secret=\"ac7de727a7\" server=\"28\" farm=\"1\" title=\"Holding on\" ispublic=\"1\" isfriend=\"0\" isfamily=\"0\" o_width=\"#{Photo2Width}\" o_height=\"#{Photo2Height}\" originalsecret=\"ac7de727a7\" originalformat=\"jpg\" />").elements['photo']	
	PhotoUrl = 'http://bar.com/foo.jpg'
	PhotoFileName = 'foo.jpg'
	
	def setup
		@decorator = PhotoDecorator.new([Width, Height])
		@svg1 = @decorator.create_svg(PhotoFileName, Photo1Info, PhotoUrl)
		@svg2 = @decorator.create_svg(PhotoFileName, Photo2Info, PhotoUrl)
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

	def test_svg_has_correct_width
		assert_equal Width, @svg1.get_elements('svg').first.attributes['width'].to_i
	end
		
	def test_svg_has_correct_height
		assert_equal Height, @svg1.get_elements('svg').first.attributes['height'].to_i
	end

	def test_svg_contains_image
		assert_not_nil @svg1.get_elements('svg/image')
	end

	def test_svg1_image_has_correct_x
		assert_equal 0, @svg1.get_elements('svg/image').first.attributes['x'].to_i
	end
		
	def test_svg1_image_has_correct_y
		assert_equal 0, @svg1.get_elements('svg/image').first.attributes['y'].to_i
	end

	def test_svg1_image_has_correct_width
		assert_equal Width, @svg1.get_elements('svg/image').first.attributes['width'].to_i
	end
		
	def test_svg1_image_has_correct_height
		assert_equal Height, @svg1.get_elements('svg/image').first.attributes['height'].to_i
	end

	def test_svg2_image_has_correct_x
		assert_equal -100, @svg2.get_elements('svg/image').first.attributes['x'].to_i
	end
		
	def test_svg2_image_has_correct_y
		assert_equal 0, @svg2.get_elements('svg/image').first.attributes['y'].to_i
	end

	def test_svg2_image_has_correct_width
		assert_equal Width + 200, @svg2.get_elements('svg/image').first.attributes['width'].to_i
	end
		
	def test_svg2_image_has_correct_height
		assert_equal Height, @svg2.get_elements('svg/image').first.attributes['height'].to_i
	end
	
end
