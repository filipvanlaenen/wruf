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

require 'photo_info'
require 'test/unit'

#
# Unit tests on PhotoInfo.
#
class PhotoInfoUnitTest < Test::Unit::TestCase

	def setup
		@info = PhotoInfo.new
	end

	def test_creates_a_file_name_with_jpg_extension
		@info.url = 'http://foo.com/bar.jpg'
		assert_equal '50cde8d0754a42f13759020d272fda8906b0f158.jpg', @info.file_name
	end

	def test_creates_a_file_name_with_png_extension
		@info.url = 'http://foo.com/bar.png'
		assert_equal '571395c62e2084be494af57c5f5023a9de054e6b.png', @info.file_name
	end

end