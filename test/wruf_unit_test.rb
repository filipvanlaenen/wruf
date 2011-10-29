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
require 'wruf_settings'
require 'test/unit'

class WrufUnitTest < Test::Unit::TestCase
	
	SecondsPerMinute = 60
	
	def setup
		@wruf = WRUF.new
	end
	
	def test_history_file_name
		@wruf.dir = '/foo'
		assert_equal '/foo/history.txt', @wruf.history_file_name
	end
	
	# too_few_seconds_since_last_rotation?
	
	def test_zero_seconds_since_last_rotation_is_too_recent
		@wruf.settings.hours = 1
		assert @wruf.too_few_seconds_since_last_rotation?(0)
	end

	def test_fifty_five_minutes_minus_one_second_since_last_rotation_is_too_recent_if_rotation_after_one_hour
		@wruf.settings.hours = 1
		assert @wruf.too_few_seconds_since_last_rotation?(55*SecondsPerMinute - 1)
	end
	
	def test_fifty_five_minutes_since_last_rotation_is_not_too_recent_if_rotation_after_one_hour
		@wruf.settings.hours = 1
		assert !@wruf.too_few_seconds_since_last_rotation?(55*SecondsPerMinute)
	end

	def test_five_hundred_ninety_five_minutes_minus_one_second_since_last_rotation_is_too_recent_if_rotation_after_ten_hours
		@wruf.settings.hours = 10
		assert @wruf.too_few_seconds_since_last_rotation?(595*SecondsPerMinute - 1)
	end
	
	def test_five_hundred_ninety_five_minutes_since_last_rotation_is_not_too_recent_if_rotation_after_ten_hours
		@wruf.settings.hours = 10
		assert !@wruf.too_few_seconds_since_last_rotation?(595*SecondsPerMinute)
	end

	# ubuntu_release_compare
	
	def test_ubuntu_release_9_04_before_12_04
		assert @wruf.ubuntu_release_compare('9.04', '12.04') < 0
	end

	def test_ubuntu_release_11_04_before_11_10
		assert @wruf.ubuntu_release_compare('11.04', '11.10') < 0
	end
	
	def test_ubuntu_release_11_04_before_12_04
		assert @wruf.ubuntu_release_compare('11.04', '12.04') < 0
	end

	def test_ubuntu_release_12_04_after_11_04
		assert @wruf.ubuntu_release_compare('12.04', '11.04') > 0
	end

	def test_ubuntu_release_11_04_equals_11_04
		assert @wruf.ubuntu_release_compare('11.04', '11.04') == 0
	end

	def test_ubuntu_release_11_10_after_11_04
		assert @wruf.ubuntu_release_compare('11.10', '11.04') > 0
	end
end
