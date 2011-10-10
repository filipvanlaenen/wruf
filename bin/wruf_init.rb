#
# Initializes a directory from which WRUF can be run.
# The directory from which WRUF will be run, must be the first parameter of the script.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'yaml'

local_wruf_dir = File.expand_path(ARGV[0])
configuration_yaml = File.join(local_sha1crk_dir, 'wruf.yaml')

wruf = WRUF.new

print "Enter the width of the screen: "
width = STDIN.readline.chomp.to_i

print "Enter the height of the screen: "
height = STDIN.readline.chomp.to_i

wruf.dimensions = [width, height]

print "Enter the photo size tolerance [0-100, default 20]: "
tolerance = STDIN.readline.chomp.to_i
if (tolerance < 1 || tolerance > 100)
	tolerance = 0.2
else
	tolerance = tolerance.to_f / 100
end
puts "Registering a tolerance of #{(tolerance * 100).to_i}%."

wruf.tolerance = tolerance

print "Enter the hours: "
wruf.hours = STDIN.readline.chomp.to_i

open(configuration_yaml, "w") { |file|
	file.write(wruf.to_yaml)
}