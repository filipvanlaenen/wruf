#
# Unit tests on PhotoHistory.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
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