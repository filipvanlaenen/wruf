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
	Photo2Width = 1480
	Photo2Height = 800
	Photo3Width = 1280
	Photo3Height = 1000
	PhotoSource = 'Flickr'
	PhotoAuthor = 'John Doe'
	PhotoUrl = 'http://bar.com/foo.jpg'
	PhotoFileName = 'e72ba8a7ffb298654e93742f9ac855dd7571d189.jpg'
	PhotoAuthorSource = "#{PhotoAuthor} @ #{PhotoSource}"
	FontFamily = 'FranklinGothic'
	TextFill = '#FFCC11'
	TitleTextIndex = 0
	AuthorSourceTextIndex = 1
	UrlTextIndex = 2
	TextFontSize = 12
	TitleFontSize = 16
	
	def setup
		settings = WrufSettings.new
		settings.dimensions = [Width, Height]
		@decorator = PhotoDecorator.new(settings)
		photo_info1 = PhotoInfo.new
		photo_info1.width = Photo1Width
		photo_info1.height = Photo1Height
		photo_info1.source = PhotoSource
		photo_info1.author = PhotoAuthor
		photo_info1.title = PhotoTitle
		photo_info1.url = PhotoUrl
		photo_info2 = PhotoInfo.new
		photo_info2.width = Photo2Width
		photo_info2.height = Photo2Height
		photo_info2.title = PhotoTitle
		photo_info2.url = PhotoUrl
		photo_info3 = PhotoInfo.new
		photo_info3.width = Photo3Width
		photo_info3.height = Photo3Height
		photo_info3.title = PhotoTitle
		photo_info3.url = PhotoUrl
		@svg1 = @decorator.create_svg(photo_info1)
		@svg2 = @decorator.create_svg(photo_info2)
		@svg3 = @decorator.create_svg(photo_info3)
	end
	
	# get_png_file_name_from_svg_file_name
	
	def assert_get_png_file_name_from_svg_file_name_correct(svg_file_name, expected_png_file_name)
		actual_png_file_name = @decorator.get_png_file_name_from_svg_file_name(svg_file_name)
		assert_equal expected_png_file_name, actual_png_file_name
	end
		
	def test_png_for_svg_at_the_end
		assert_get_png_file_name_from_svg_file_name_correct('foo-decorated.svg', 'foo-decorated.png')
	end

	def test_png_for_svg_in_the_middle
		assert_get_png_file_name_from_svg_file_name_correct('foo.svg.bar-decorated.svg', 'foo.svg.bar-decorated.png')
	end

	# get_svg_file_name_from_photo_file_name

	def assert_get_svg_file_name_from_photo_file_name_correct(photo_file_name, expected_svg_file_name)
		actual_svg_file_name = @decorator.get_svg_file_name_from_photo_file_name(photo_file_name)
		assert_equal expected_svg_file_name, actual_svg_file_name
	end
	
	def test_svg_for_jpg_at_the_end
		assert_get_svg_file_name_from_photo_file_name_correct('foo.jpg', 'foo-decorated.svg')
	end
	
	def test_svg_for_png_at_the_end
		assert_get_svg_file_name_from_photo_file_name_correct('foo.png', 'foo-decorated.svg')
	end
	
	# <svg>

	def test_svg_has_correct_width
		assert_equal Width, @svg1.get_elements('svg').first.attributes['width'].to_i
	end
		
	def test_svg_has_correct_height
		assert_equal Height, @svg1.get_elements('svg').first.attributes['height'].to_i
	end

	def test_svg_contains_image
		assert !@svg1.get_elements('svg/image').empty?
	end

	# <svg/image>

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

	# <svg/text>
	
	def test_svg_contains_two_texts
		assert_equal 3, @svg1.get_elements('svg/text').size
	end

	# <svg/text[Title]>

	def test_svg_title_text_has_correct_x
		assert_equal Width / 10, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['x'].to_i
	end
	
	def test_svg_title_text_has_correct_y
		assert_equal 9 * Height / 10 - TitleFontSize - TextFontSize, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['y'].to_i
	end
	
	def test_svg_title_text_has_correct_font_family
		assert_equal FontFamily, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-family']
	end
	
	def test_svg_title_text_has_correct_font_weight
		assert_equal 'bold', @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-weight']
	end

	def test_svg_title_text_has_correct_font_size
		assert_equal TitleFontSize, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['font-size'].to_i
	end

	def test_svg_title_text_has_correct_fill
		assert_equal TextFill, @svg1.get_elements('svg/text')[TitleTextIndex].attributes['fill']
	end

	def test_svg_title_text_has_correct_content
		assert_equal PhotoTitle, @svg1.get_elements('svg/text')[TitleTextIndex].text
	end

	# <svg/text[Author and Source]>
	
	def test_svg_author_source_text_has_correct_x
		assert_equal Width / 10, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].attributes['x'].to_i
	end
	
	def test_svg_author_source_text_has_correct_y
		assert_equal 9 * Height / 10  - TextFontSize, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].attributes['y'].to_i
	end
	
	def test_svg_author_source_text_has_correct_font_family
		assert_equal FontFamily, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].attributes['font-family']
	end
	
	def test_svg_author_source_text_has_correct_font_size
		assert_equal TextFontSize, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].attributes['font-size'].to_i
	end

	def test_svg_author_source_text_has_correct_fill
		assert_equal TextFill, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].attributes['fill']
	end

	def test_svg_author_source_text_has_correct_content
		assert_equal PhotoAuthorSource, @svg1.get_elements('svg/text')[AuthorSourceTextIndex].text
	end

	# <svg/text[URL]>
	
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
		assert_equal TextFontSize, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['font-size'].to_i
	end

	def test_svg_url_text_has_correct_fill
		assert_equal TextFill, @svg1.get_elements('svg/text')[UrlTextIndex].attributes['fill']
	end

	def test_svg_url_text_has_correct_content
		assert_equal PhotoUrl, @svg1.get_elements('svg/text')[UrlTextIndex].text
	end
end
