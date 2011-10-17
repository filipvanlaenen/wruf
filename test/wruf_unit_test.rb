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
# Unit tests on Wruf.
#

require 'wruf'
require 'test/unit'

class WrufUnitTest < Test::Unit::TestCase
	
	def setup
		@wruf = WRUF.new
	end
	
	def test_ubuntu_release_9_04_before_12_04
		assert @wruf.ubuntu_release_compare('9.04', '12.04') < 0
	end

	def test_ubuntu_release_11_04_before_11_10
		assert @wruf.ubuntu_release_compare('11.04', '11.10') < 0
	end
	
	def test_ubuntu_release_11_04_before_12_04
		assert @wruf.ubuntu_release_compare('11.04', '12.04') < 0
	end

	def test_ubuntu_release_11_04_equals_11_04
		assert @wruf.ubuntu_release_compare('11.04', '11.04') == 0
	end

	def test_ubuntu_release_11_10_after_11_04
		assert @wruf.ubuntu_release_compare('11.10', '11.04') > 0
	end
end
