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
	
	def create_svg_file(photo_file_name, photo_info, photo_url)
		doc = REXML::Document.new
		doc << REXML::XMLDecl.new('1.0', nil, 'no')
		doctype = REXML::DocType.new(['svg', 'PUBLIC', '-//W3C//DTD SVG 1.1//EN', 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'])
		doc << doctype
		svg = REXML::Element.new('svg')
		svg.add_attribute('version', '1.1')
		svg.add_namespace('http://www.w3.org/2000/svg')
		svg.add_namespace('xmlns:xlink', 'http://www.w3.org/1999/xlink')
		svg.add_attribute('width', @width)
		svg.add_attribute('height', @height)
		image = REXML::Element.new('image')
		image.add_attribute('x', '0')
		image.add_attribute('y', '0')
		image.add_attribute('width', photo_info.attributes["o_width"])
		image.add_attribute('height', photo_info.attributes["o_height"])
		image.add_attribute('xlink:href', photo_file_name)
		svg << image
		doc << svg
		return doc.to_s
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
			file.write(svg)
		}
	end

	def save_svg_to_file(photo_file_name, svg)
		svg_file_name = get_svg_file_name_from_photo_file_name(photo_file_name)
		write_svg_to_file(svg_file_name, svg)
		return svg_file_name
	end

	def decorate(photo_file_name, photo_info, photo_url)
		svg = create_svg_file(photo_file_name, photo_info, photo_url)
		svg_file_name = save_svg_to_file(photo_file_name, svg)
		png_file_name = convert_svg_to_jpg(svg_file_name)
		return png_file_name
	end

end