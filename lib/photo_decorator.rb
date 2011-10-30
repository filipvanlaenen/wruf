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

	FontFamily = 'FranklinGothic'
	Bold = 'bold'
	TextFill = '#FFCC11'
	TextFontSize = 12
	TitleFontSize = 16

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
		text.add_attribute('font-family', FontFamily)
		text.add_attribute('fill', TextFill)
		return text
	end
	
	def create_title_text(photo_info)
		text = create_text
		text.add_attribute('font-size', TitleFontSize)
		text.add_attribute('font-weight', Bold)
		text.add_attribute('x', @width / 10)
		text.add_attribute('y', 9 * @height / 10 - TitleFontSize)
		text.text = photo_info.title
		return text
	end
	
	def create_url_text(photo_info)
		text = create_text
		text.add_attribute('x', @width / 10)
		text.add_attribute('y', 9 * @height / 10)
		text.add_attribute('font-size', TextFontSize)
		text.text = photo_info.url
		return text
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
		svg << create_title_text(photo_info)
		svg << create_url_text(photo_info)
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