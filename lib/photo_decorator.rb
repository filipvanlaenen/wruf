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
# A class to decorate a photo.
#
class PhotoDecorator

	TextFontFamily = 'Ubuntu'
	CalendarFontFamily = 'Ubuntu'
	Bold = 'bold'
	TextFill = '#FFCC11'
	CalendarWeekdayFill = '#FFCC11'
	CalendarSundayFill = '#FF0000'
	PastOpacity = 0.2
	TodayOpacity = 1
	FutureOpacity = 0.5
	TextFontSize = 12
	TitleFontSize = 16
	CalendarFontSize = 32
	TwoWeeks = (1..2)
	DaysOfTheWeek = (1..7)

	def initialize(settings)
		@width = settings.dimensions[0]
		@height = settings.dimensions[1]	
	end
	
	def set_dimensions_on_svg(svg)
		svg.add_attribute('width', @width)
		svg.add_attribute('height', @height)
	end
	
	def set_dimensions_on_svg_image(image, photo_info)
		scale_x = @width.to_f / photo_info.width.to_f
		scale_y = @height.to_f / photo_info.height.to_f
		scale = [scale_x, scale_y].max
		x_offset = (scale * photo_info.width.to_f - @width.to_f) / 2.to_f
		y_offset = (scale * photo_info.height.to_f - @height.to_f) / 2.to_f
		image.add_attribute('x', -x_offset)
		image.add_attribute('y', -y_offset)
		image.add_attribute('width', @width + 2.to_f * x_offset)
		image.add_attribute('height', @height + 2.to_f * y_offset) 
	end
	
	def set_link_on_svg_image(image, photo_info)
		image.add_attribute('xlink:href', photo_info.file_name)
	end
	
	def create_text
		text = REXML::Element.new('text')
		text.add_attribute('font-family', TextFontFamily)
		text.add_attribute('fill', TextFill)
		return text
	end
	
	def create_title_text(photo_info)
		text = create_text
		text.add_attribute('font-size', TitleFontSize)
		text.add_attribute('font-weight', Bold)
		text.add_attribute('x', @width / 20)
		text.add_attribute('y', 9 * @height / 10 - TitleFontSize - TextFontSize)
		text.text = photo_info.title
		return text
	end
	
	def create_author_source_text(photo_info)
		text = create_text
		text.add_attribute('x', @width / 20)
		text.add_attribute('y', 9 * @height / 10 - TextFontSize)
		text.add_attribute('font-size', TextFontSize)
		text.text = "#{photo_info.author} @ #{photo_info.source}"
		return text
	end
	
	def create_url_text(photo_info)
		text = create_text
		text.add_attribute('x', @width / 20)
		text.add_attribute('y', 9 * @height / 10)
		text.add_attribute('font-size', TextFontSize)
		text.text = photo_info.ref_url
		return text
	end

	def create_photo_info_group(photo_info)
		group = REXML::Element.new('g')
		group.add_attribute('id', 'photo_info')
		group << create_title_text(photo_info)
		group << create_author_source_text(photo_info)
		group << create_url_text(photo_info)
		return group
	end
	
	def get_calendar_fill(i)
		if (i == 7)
			return CalendarSundayFill
		else
			return CalendarWeekdayFill
		end
	end
	
	def get_calendar_x(i)
		return ((CalendarFontSize * (i - 7)).to_f * 1.4).to_i
	end

	def get_calendar_y(j)
		return ((CalendarFontSize * j).to_f * 1.4).to_i
	end
	
	def mday(date, weeks, day)
		wday = date.wday
		if (wday == 0)
			wday = 7
		end
		return (date - wday + day + (7 * weeks)).mday
	end

	def create_last_week(today)
		group = REXML::Element.new('g')
		group.add_attribute('id', 'last_week')
		group.add_attribute('opacity', PastOpacity)
		DaysOfTheWeek.each do | i |
			text = REXML::Element.new('text')
			text.add_attribute('fill', get_calendar_fill(i))
			text.add_attribute('x', get_calendar_x(i))
			text.add_attribute('y', get_calendar_y(0))
			text.text = mday(today, -1, i)
			group << text
		end
		return group
	end
	
	def get_day_opacity_for_this_week(today, day)
		wday = today.wday
		if (wday == 0)
			wday = 7
		end
		if (day == wday)
			return TodayOpacity
		elsif (day < wday)
			return PastOpacity
		else
			return FutureOpacity
		end
	end
	
	def create_this_week(today)
		group = REXML::Element.new('g')
		group.add_attribute('id', 'this_week')
		DaysOfTheWeek.each do | i |
			text = REXML::Element.new('text')
			text.add_attribute('fill', get_calendar_fill(i))
			text.add_attribute('x', get_calendar_x(i))
			text.add_attribute('y', get_calendar_y(1))
			text.add_attribute('opacity', get_day_opacity_for_this_week(today, i))
			text.text = mday(today, 0, i)
			group << text
		end
		return group
	end
	
	def create_next_two_weeks(today)
		group = REXML::Element.new('g')
		group.add_attribute('id', 'next_two_weeks')
		group.add_attribute('opacity', FutureOpacity)
		TwoWeeks.each do | j |
			DaysOfTheWeek.each do | i |
				text = REXML::Element.new('text')
				text.add_attribute('fill', get_calendar_fill(i))
				text.add_attribute('x', get_calendar_x(i))
				text.add_attribute('y', get_calendar_y(j + 1))
				text.text = mday(today, j, i)
				group << text
			end
		end
		return group
	end
		
	def create_calendar_group
		group = REXML::Element.new('g')
		group.add_attribute('id', 'calendar')
		horizontal_translation = 19 * @width / 20
		vertical_translation = @height / 10
		group.add_attribute('transform', "translate(#{horizontal_translation},#{vertical_translation})")
		group.add_attribute('font-family', CalendarFontFamily)
		group.add_attribute('font-size', CalendarFontSize)
		group.add_attribute('font-weight', Bold)
		group.add_attribute('text-anchor', 'middle')
		today = Date.today
		group << create_last_week(today)
		group << create_this_week(today)
		group << create_next_two_weeks(today)
		return group
	end
	
	def create_svg(photo_info)
		doc = REXML::Document.new
		doc << REXML::XMLDecl.new('1.0', nil, 'no')
		doctype = REXML::DocType.new(['svg', 'PUBLIC', '-//W3C//DTD SVG 1.1//EN', 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'])
		doc << doctype
		svg = REXML::Element.new('svg')
		svg.add_attribute('version', '1.1')
		svg.add_namespace('http://www.w3.org/2000/svg')
		svg.add_namespace('xmlns:xlink', 'http://www.w3.org/1999/xlink')
		set_dimensions_on_svg(svg)
		image = REXML::Element.new('image')
		set_dimensions_on_svg_image(image, photo_info)
		set_link_on_svg_image(image, photo_info)
		svg << image
		svg << create_photo_info_group(photo_info)
		svg << create_calendar_group
		doc << svg
		return doc
	end
	
	def get_png_file_name_from_svg_file_name(svg_file_name)
		return svg_file_name.sub(/\.svg$/, '.png')
	end
	
	def	convert_svg_to_jpg(svg_file_name)
		png_file_name = get_png_file_name_from_svg_file_name(svg_file_name)
		system("rsvg-convert #{svg_file_name} -o #{png_file_name}")
		return png_file_name
	end
	
	def get_svg_file_name_from_photo_file_name(photo_file_name)
		return photo_file_name.sub(/\.\w+$/, '-decorated.svg')
	end
	
	def write_svg_to_file(svg_file_name, svg)
		open(svg_file_name, "w") { |file|
			file.write(svg.to_s)
		}
	end

	def save_svg_to_file(photo_file_name, svg)
		svg_file_name = get_svg_file_name_from_photo_file_name(photo_file_name)
		write_svg_to_file(svg_file_name, svg)
		return svg_file_name
	end

	def decorate(photo_info, dir)
		svg = create_svg(photo_info)
		svg_file_name = save_svg_to_file(File.join(dir, photo_info.file_name), svg)
		png_file_name = convert_svg_to_jpg(svg_file_name)
		return png_file_name
	end

end