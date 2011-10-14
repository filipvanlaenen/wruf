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

#
# Unit tests on PhotoDecorator.
#

require 'photo_decorator'
require 'test/unit'
require 'rexml/document'

class PhotoDecoratorUnitTest < Test::Unit::TestCase
	
	Width = 1280
	Height = 800
	PhotoTitle = 'Holding on'
	Photo1Width = 2560
	Photo1Height = 1600
	Photo1Info = REXML::Document.new("<photo id=\"41942696\" owner=\"23548413@N00\" secret=\"ac7de727a7\" server=\"28\" farm=\"1\" title=\"#{PhotoTitle}\" ispublic=\"1\" isfriend=\"0\" isfamily=\"0\" o_width=\"#{Photo1Width}\" o_height=\"#{Photo1Height}\" originalsecret=\"ac7de727a7\" originalformat=\"jpg\" />").elements['photo']
	Photo2Width = 1480
	Photo2Height = 800
	Photo2Info = REXML::Document.new("<photo id=\"41942696\" owner=\"23548413@N00\" secret=\"ac7de727a7\" server=\"28\" farm=\"1\" title=\"#{PhotoTitle}\" ispublic=\"1\" isfriend=\"0\" isfamily=\"0\" o_width=\"#{Photo2Width}\" o_height=\"#{Photo2Height}\" originalsecret=\"ac7de727a7\" originalformat=\"jpg\" />").elements['photo']	
	Photo3Width = 1280
	Photo3Height = 1000
	Photo3Info = REXML::Document.new("<photo id=\"41942696\" owner=\"23548413@N00\" secret=\"ac7de727a7\" server=\"28\" farm=\"1\" title=\"#{PhotoTitle}\" ispublic=\"1\" isfriend=\"0\" isfamily=\"0\" o_width=\"#{Photo3Width}\" o_height=\"#{Photo3Height}\" originalsecret=\"ac7de727a7\" originalformat=\"jpg\" />").elements['photo']	
	PhotoUrl = 'http://bar.com/foo.jpg'
	PhotoFileName = 'foo.jpg'
	FontFamily = 'FranklinGothic'
	TextFill = '#ffff00'
	TitleTextIndex = 0
	UrlTextIndex = 1
	UrlTextFontSize = 12
	
	def setup
		@decorator = PhotoDecorator.new([Width, Height])
		@svg1 = @decorator.create_svg(PhotoFileName, Photo1Info, PhotoUrl)
		@svg2 = @decorator.create_svg(PhotoFileName, Photo2Info, PhotoUrl)
		@svg3 = @decorator.create_svg(PhotoFileName, Photo3Info, PhotoUrl)
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
		assert !@svg1.get_elements('svg/image').empty?
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
	
	def test_svg3_image_has_correct_x
		assert_equal 0, @svg3.get_elements('svg/image').first.attributes['x'].to_i
	end
		
	def test_svg3_image_has_correct_y
		assert_equal -100, @svg3.get_elements('svg/image').first.attributes['y'].to_i
	end

	def test_svg3_image_has_correct_width
		assert_equal Width, @svg3.get_elements('svg/image').first.attributes['width'].to_i
	end
		
	def test_svg3_image_has_correct_height
		assert_equal Height + 200, @svg3.get_elements('svg/image').first.attributes['height'].to_i
	end
	
	def test_svg1_image_has_correct_xlink_href
		assert_equal PhotoFileName, @svg1.get_elements('svg/image').first.attributes['xlink:href']
	end
	
	def test_svg_contains_two_texts
		assert_equal 2, @svg1.get_elements('svg/text').size
	end

	def test_svg_title_text_has_correct_x
		assert_equal Width / 10, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['x'].to_i
	end
	
	def test_svg_title_text_has_correct_y
		assert_equal 9 * Height / 10 - UrlTextFontSize, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['y'].to_i
	end
	
	def test_svg_title_text_has_correct_font_family
		assert_equal FontFamily, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-family']
	end
	
	def test_svg_title_text_has_correct_font_weight
		assert_equal 'bold', @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-weight']
	end

	def test_svg_title_text_has_correct_font_size
		assert_equal 16, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-size'].to_i
	end

	def test_svg_title_text_has_correct_fill
		assert_equal TextFill, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['fill']
	end

	def test_svg_title_text_has_correct_content
		assert_equal PhotoTitle, @svg1.get_elements('svg/text')[TitleTextIndex].text
	end
	
	def test_svg_url_text_has_correct_x
		assert_equal Width / 10, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['x'].to_i
	end
	
	def test_svg_url_text_has_correct_y
		assert_equal 9 * Height / 10, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['y'].to_i
	end
	
	def test_svg_url_text_has_correct_font_family
		assert_equal FontFamily, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['font-family']
	end
	
	def test_svg_url_text_has_correct_font_size
		assert_equal UrlTextFontSize, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['font-size'].to_i
	end

	def test_svg_url_text_has_correct_fill
		assert_equal TextFill, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['fill']
	end

	def test_svg_url_text_has_correct_content
		assert_equal PhotoUrl, @svg1.get_elements('svg/text')[UrlTextIndex].text
	end
end
