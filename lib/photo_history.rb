#
# A class keeping track of the photo history.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'photo_history'

class PhotoHistory

	def initialize(file_name, urls)
		@urls = urls
		@file_name = file_name
	end
	
	def include?(url)
		return @urls.include?(url)
	end
	
	def record(url)
		file = File.open(@file_name, 'a')
		file.puts(url)
		file.close
	end

	def self.load_history(file_name)
		lines = []
		if (File.exist?(file_name))
			file = File.open(file_name, 'r')
			line = file.gets
			while (line)
				lines << line.strip
				line = file.gets
			end
			file.close		
		end
		return PhotoHistory.new(file_name, lines)
	end

end