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
	PhotoRefUrl = 'http://bar.com/foo'
	PhotoFileName = 'e72ba8a7ffb298654e93742f9ac855dd7571d189.jpg'
	PhotoAuthorSource = "#{PhotoAuthor} @ #{PhotoSource}"
	FontFamily = 'Ubuntu'
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
		photo_info1.ref_url = PhotoRefUrl
		photo_info2 = PhotoInfo.new
		photo_info2.width = Photo2Width
		photo_info2.height = Photo2Height
		photo_info2.title = PhotoTitle
		photo_info2.url = PhotoUrl
		photo_info2.ref_url = PhotoRefUrl
		photo_info3 = PhotoInfo.new
		photo_info3.width = Photo3Width
		photo_info3.height = Photo3Height
		photo_info3.title = PhotoTitle
		photo_info3.url = PhotoUrl
		photo_info3.ref_url = PhotoRefUrl
		@svg1 = @decorator.create_svg(photo_info1)
		@svg2 = @decorator.create_svg(photo_info2)
		@svg3 = @decorator.create_svg(photo_info3)
	end
	
	# get_day_opacity_for_this_week

	def test_day_opacity_for_monday_today
		assert_equal PhotoDecorator::TodayOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 7), 1)
	end
	
	def test_day_opacity_for_tuesday_on_monday
		assert_equal PhotoDecorator::FutureOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 7), 2)
	end

	def test_day_opacity_for_sunday_on_monday
		assert_equal PhotoDecorator::FutureOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 7), 7)
	end

	def test_day_opacity_for_monday_on_friday
		assert_equal PhotoDecorator::PastOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 4), 1)
	end

	def test_day_opacity_for_friday_today
		assert_equal PhotoDecorator::TodayOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 4), 5)
	end

	def test_day_opacity_for_saturday_on_friday
		assert_equal PhotoDecorator::FutureOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 4), 6)
	end

	def test_day_opacity_for_sunday_on_friday
		assert_equal PhotoDecorator::FutureOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 4), 7)
	end
	
	def test_day_opacity_for_saturday_on_sunday
		assert_equal PhotoDecorator::PastOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 6), 6)
	end

	def test_day_opacity_for_sunday_today
		assert_equal PhotoDecorator::TodayOpacity, @decorator.get_day_opacity_for_this_week(Date.civil(2011, 11, 6), 7)
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
	
	# mday
	
	def test_mday_for_monday_of_week_0_for_2011_11_04_should_be_31
		assert_equal 31, @decorator.mday(Date.civil(2011, 11, 4), 0, 1)
	end

	def test_mday_for_friday_of_week_0_for_2011_11_04_should_be_4
		assert_equal 4, @decorator.mday(Date.civil(2011, 11, 4), 0, 5)
	end
	
	def test_mday_for_sunday_of_week_0_for_2011_11_04_should_be_6
		assert_equal 6, @decorator.mday(Date.civil(2011, 11, 4), 0, 7)
	end

	def test_mday_for_sunday_of_week_0_for_2011_11_06_should_be_6
		assert_equal 6, @decorator.mday(Date.civil(2011, 11, 6), 0, 7)
	end

	def test_mday_for_sunday_of_last_week_for_2011_11_06_should_be_30
		assert_equal 30, @decorator.mday(Date.civil(2011, 11, 6), -1, 7)
	end

	def test_mday_for_sunday_of_next_week_for_2011_11_06_should_be_13
		assert_equal 13, @decorator.mday(Date.civil(2011, 11, 6), 1, 7)
	end

	def test_mday_for_sunday_of_week_after_next_week_for_2011_11_06_should_be_20
		assert_equal 20, @decorator.mday(Date.civil(2011, 11, 6), 2, 7)
	end

	# <svg>

	def test_svg_has_correct_width
		assert_equal Width, @svg1.get_elements('svg').first.attributes['width'].to_i
	end
		
	def test_svg_has_correct_height
		assert_equal Height, @svg1.get_elements('svg').first.attributes['height'].to_i
	end

	# <svg/image>

	def test_svg_contains_image
		assert !@svg1.get_elements('svg/image').empty?
	end
	
	def get_image
		return @svg1.get_elements('svg/image').first
	end

	def test_svg1_image_has_correct_x
		assert_equal 0, get_image.attributes['x'].to_i
	end
		
	def test_svg1_image_has_correct_y
		assert_equal 0, get_image.attributes['y'].to_i
	end

	def test_svg1_image_has_correct_width
		assert_equal Width, get_image.attributes['width'].to_i
	end
		
	def test_svg1_image_has_correct_height
		assert_equal Height, get_image.attributes['height'].to_i
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

	def test_svg_image_has_correct_xlink_href
		assert_equal PhotoFileName, get_image.attributes['xlink:href']
	end
	
	# <svg/g[photo_info]/text>

	def test_has_photo_info_group
		assert !@svg1.get_elements('svg/g').select { |e| e.attributes['id'] == 'photo_info' }.empty?
	end

	def get_photo_info_group
		return @svg1.get_elements('svg/g').select { |e| e.attributes['id'] == 'photo_info' }.first
	end	

	def test_photo_info_group_has_three_text_elements
		assert_equal 3, get_photo_info_group.get_elements('text').size
	end

	# <svg/g[photo_info]/text[Title]>
	
	def get_title_text
		return get_photo_info_group.get_elements('text')[TitleTextIndex]
	end

	def test_svg_title_text_has_correct_x
		assert_equal Width / 20, get_title_text.attributes['x'].to_i
	end
	
	def test_svg_title_text_has_correct_y
		assert_equal 9 * Height / 10 - TitleFontSize - 3 * TextFontSize / 2, get_title_text.attributes['y'].to_i
	end
	
	def test_svg_title_text_has_correct_font_family
		assert_equal FontFamily, get_title_text.attributes['font-family']
	end
	
	def test_svg_title_text_has_correct_font_weight
		assert_equal 'bold', get_title_text.attributes['font-weight']
	end

	def test_svg_title_text_has_correct_font_size
		assert_equal TitleFontSize, get_title_text.attributes['font-size'].to_i
	end

	def test_svg_title_text_has_correct_fill
		assert_equal TextFill, get_title_text.attributes['fill']
	end

	def test_svg_title_text_has_correct_content
		assert_equal PhotoTitle, get_title_text.text
	end

	# <svg/g[photo_info]/text[Author and Source]>

	def get_author_source_text
		return get_photo_info_group.get_elements('text')[AuthorSourceTextIndex]
	end	
	
	def test_svg_author_source_text_has_correct_x
		assert_equal Width / 20, get_author_source_text.attributes['x'].to_i
	end
	
	def test_svg_author_source_text_has_correct_y
		assert_equal 9 * Height / 10  - 3 * TextFontSize / 2, get_author_source_text.attributes['y'].to_i
	end
	
	def test_svg_author_source_text_has_correct_font_family
		assert_equal FontFamily, get_author_source_text.attributes['font-family']
	end
	
	def test_svg_author_source_text_has_correct_font_size
		assert_equal TextFontSize, get_author_source_text.attributes['font-size'].to_i
	end

	def test_svg_author_source_text_has_correct_fill
		assert_equal TextFill, get_author_source_text.attributes['fill']
	end

	def test_svg_author_source_text_has_correct_content
		assert_equal PhotoAuthorSource, get_author_source_text.text
	end

	# <svg/g[photo_info]/text[URL]>
	
	def get_ref_url_text
		return get_photo_info_group.get_elements('text')[UrlTextIndex]
	end	

	def test_svg_url_text_has_correct_x
		assert_equal Width / 20, get_ref_url_text.attributes['x'].to_i
	end
	
	def test_svg_url_text_has_correct_y
		assert_equal 9 * Height / 10, get_ref_url_text.attributes['y'].to_i
	end
	
	def test_svg_url_text_has_correct_font_family
		assert_equal FontFamily, get_ref_url_text.attributes['font-family']
	end
	
	def test_svg_url_text_has_correct_font_size
		assert_equal TextFontSize, get_ref_url_text.attributes['font-size'].to_i
	end

	def test_svg_url_text_has_correct_fill
		assert_equal TextFill, get_ref_url_text.attributes['fill']
	end

	def test_svg_url_text_has_correct_content
		assert_equal PhotoRefUrl, get_ref_url_text.text
	end
	
	# <svg/g[calendar]>

	def test_has_calendar_group
		assert !@svg1.get_elements('svg/g').select { |e| e.attributes['id'] == 'calendar' }.empty?
	end

	def get_calendar_group
		return @svg1.get_elements('svg/g').select { |e| e.attributes['id'] == 'calendar' }.first
	end
	
	def test_calendar_is_transformed_correctly
		width = 19 * Width / 20
		height = Height / 10
		assert_equal "translate(#{width},#{height})", get_calendar_group.attributes['transform']
	end
	
	def test_calendar_has_correct_font_family
		assert_equal PhotoDecorator::CalendarFontFamily, get_calendar_group.attributes['font-family']
	end

	def test_calendar_has_correct_font_size
		assert_equal PhotoDecorator::CalendarFontSize, get_calendar_group.attributes['font-size'].to_i
	end

	def test_calendar_has_correct_font_weight
		assert_equal 'bold', get_calendar_group.attributes['font-weight']
	end

	def test_calendar_has_correct_text_anchor
		assert_equal 'middle', get_calendar_group.attributes['text-anchor']
	end

	def test_calendar_group_has_three_groups
		assert_equal 3, get_calendar_group.get_elements('g').size
	end
	
	# <svg/g[calendar]/g[last_week]>
	
	def get_last_week_group
		return get_calendar_group.get_elements('g').select { |e| e.attributes['id'] == 'last_week' }.first
	end

	def test_last_week_has_past_opacity
		assert_equal PhotoDecorator::PastOpacity, get_last_week_group.attributes['opacity'].to_f
	end

	def test_last_week_has_seven_text_elements
		assert_equal 7, get_last_week_group.get_elements('text').size
	end	

	def test_last_week_has_correct_x
		for i in 0..6
			assert_equal ((PhotoDecorator::CalendarFontSize * (i - 6)).to_f * 1.4).to_i, get_last_week_group.get_elements('text')[i].attributes['x'].to_i
		end
	end

	def test_last_week_has_correct_y
		for i in 0..6
			assert_equal 0, get_last_week_group.get_elements('text')[i].attributes['y'].to_i
		end
	end

	def test_last_week_has_correct_fill_for_weekdays
		for i in 0..5
			assert_equal PhotoDecorator::CalendarWeekdayFill, get_last_week_group.get_elements('text')[i].attributes['fill']
		end
	end

	def test_last_week_has_correct_fill_for_sunday
		assert_equal PhotoDecorator::CalendarSundayFill, get_last_week_group.get_elements('text')[6].attributes['fill']
	end

	# <svg/g[calendar]/g[this_week]>
	
	def get_this_week_group
		return get_calendar_group.get_elements('g').select { |e| e.attributes['id'] == 'this_week' }.first
	end

	def test_this_week_has_seven_text_elements
		assert_equal 7, get_this_week_group.get_elements('text').size
	end

	def test_this_week_has_correct_x
		for i in 0..6
			assert_equal ((PhotoDecorator::CalendarFontSize * (i - 6)).to_f * 1.4).to_i, get_this_week_group.get_elements('text')[i].attributes['x'].to_i
		end
	end

	def test_this_week_has_correct_y
		expected_y = (PhotoDecorator::CalendarFontSize.to_f * 1.4).to_i
		for i in 0..6
			assert_equal expected_y, get_this_week_group.get_elements('text')[i].attributes['y'].to_i
		end
	end
	
	def test_this_week_has_correct_fill_for_weekdays
		for i in 0..5
			assert_equal PhotoDecorator::CalendarWeekdayFill, get_this_week_group.get_elements('text')[i].attributes['fill']
		end
	end

	def test_this_week_has_correct_fill_for_sunday
		assert_equal PhotoDecorator::CalendarSundayFill, get_this_week_group.get_elements('text')[6].attributes['fill']
	end

	# <svg/g[calendar]/g[next_two_weeks]>
	
	def get_next_two_weeks_group
		return get_calendar_group.get_elements('g').select { |e| e.attributes['id'] == 'next_two_weeks' }.first
	end

	def test_next_two_weeks_has_future_opacity
		assert_equal PhotoDecorator::FutureOpacity, get_next_two_weeks_group.attributes['opacity'].to_f
	end


	def test_next_two_weeks_has_fourteen_text_elements
		assert_equal 14, get_next_two_weeks_group.get_elements('text').size
	end	

	def test_next_two_weeks_has_correct_x
		for i in 0..13
			assert_equal ((PhotoDecorator::CalendarFontSize * ((i % 7) - 6)).to_f * 1.4).to_i, get_next_two_weeks_group.get_elements('text')[i].attributes['x'].to_i
		end
	end

	def test_next_week_has_correct_y
		expected_y = ((PhotoDecorator::CalendarFontSize * 2).to_f * 1.4).to_i
		for i in 0..6
			assert_equal expected_y, get_next_two_weeks_group.get_elements('text')[i].attributes['y'].to_i
		end
	end

	def test_week_after_next_week_has_correct_y
		expected_y = ((PhotoDecorator::CalendarFontSize * 3).to_f * 1.4).to_i
		for i in 7..13
			assert_equal expected_y, get_next_two_weeks_group.get_elements('text')[i].attributes['y'].to_i
		end
	end

	def test_next_week_has_correct_fill_for_weekdays
		for i in 0..5
			assert_equal PhotoDecorator::CalendarWeekdayFill, get_next_two_weeks_group.get_elements('text')[i].attributes['fill']
		end
	end

	def test_week_after_next_week_has_correct_fill_for_weekdays
		for i in 7..12
			assert_equal PhotoDecorator::CalendarWeekdayFill, get_next_two_weeks_group.get_elements('text')[i].attributes['fill']
		end
	end

	def test_next_week_has_correct_fill_for_sunday
		assert_equal PhotoDecorator::CalendarSundayFill, get_next_two_weeks_group.get_elements('text')[6].attributes['fill']
	end

	def test_week_after_next_week_has_correct_fill_for_sunday
		assert_equal PhotoDecorator::CalendarSundayFill, get_next_two_weeks_group.get_elements('text')[13].attributes['fill']
	end
end
