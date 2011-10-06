#
# A class to decorate a photo.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

class PhotoDecorator

	def initialize(dims)
		@width = dims[0]
		@height = dims[1]	
	end
	
	def set_dimensions_on_svg(svg)
		svg.add_attribute('width', @width)
		svg.add_attribute('height', @height)
	end
	
	def set_dimensions_on_svg_image(image, photo_info)
		scale_x = @width.to_f / photo_info.attributes["o_width"].to_f
		scale_y = @height.to_f / photo_info.attributes["o_height"].to_f
		scale = [scale_x, scale_y].max
		x_offset = (scale * photo_info.attributes["o_width"].to_f - @width.to_f) / 2.to_f
		y_offset = (scale * photo_info.attributes["o_height"].to_f - @height.to_f) / 2.to_f
		image.add_attribute('x', -x_offset)
		image.add_attribute('y', -y_offset)
		image.add_attribute('width', @width + 2.to_f * x_offset)
		image.add_attribute('height', @height + 2.to_f * y_offset) 
	end
	
	def set_link_on_svg_image(image, photo_file_name)
		image.add_attribute('xlink:href', photo_file_name)
	end
	
	def create_svg(photo_file_name, photo_info, photo_url)
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
		set_link_on_svg_image(image, photo_file_name)
		svg << image
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
		return photo_file_name.sub(/\.\w+$/, '.svg')
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

	def decorate(photo_file_name, photo_info, photo_url)
		svg = create_svg(photo_file_name, photo_info, photo_url)
		svg_file_name = save_svg_to_file(photo_file_name, svg)
		png_file_name = convert_svg_to_jpg(svg_file_name)
		return png_file_name
	end

end