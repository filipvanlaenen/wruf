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
# Unit tests on PhotoHistory.
#

require 'photo_history'
require 'test/unit'

class PhotoHistoryUnitTest < Test::Unit::TestCase

	HistoryFileName = 'history.txt'
	BarUrl = 'http://foo.com/bar.jpg'
	QuxUrl = 'http://foo.com/qux.jpg'
	HistoryArray = [BarUrl]

	def setup
		@history = PhotoHistory.new(HistoryFileName, HistoryArray)
	end
	
	def test_must_include_element
		assert @history.include?(BarUrl)
	end

	def test_must_not_include_other_element
		assert !@history.include?(QuxUrl)
	end

end