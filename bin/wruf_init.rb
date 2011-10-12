#
# Initializes a directory from which WRUF can be run.
# The directory from which WRUF will be run, must be the first parameter of the script.
#
# Author: Filip van Laenen <f.a.vanlaenen@ieee.org>
#

require 'yaml'
require 'wruf'

local_wruf_dir = File.expand_path(ARGV[0])
configuration_yaml = File.join(local_wruf_dir, 'wruf.yaml')

if (File.exist?(configuration_yaml))
	value_status = 'current'
	wruf = WRUF.load(local_wruf_dir)
else
	value_status = 'default'
	wruf = WRUF.new
	wruf.dimensions = [1280, 800]
	wruf.tolerance = 0.2
	wruf.hours = 24
end

print "Enter the minimal width for the wallpaper photo [#{value_status} #{wruf.dimensions[0]}]: "
width = STDIN.readline.chomp.to_i

print "Enter the minimal height for the wallpaper photo [#{value_status} #{wruf.dimensions[1]}]: "
height = STDIN.readline.chomp.to_i

wruf.dimensions = [width, height]

print "Enter the photo size tolerance [0-100, #{value_status} #{(wruf.tolerance * 100).to_i}]: "
tolerance = STDIN.readline.chomp.to_i
if (tolerance < 1 || tolerance > 100)
	tolerance = 0.2
else
	tolerance = tolerance.to_f / 100
end
puts "Registering a tolerance of #{(tolerance * 100).to_i}%."

wruf.tolerance = tolerance

print "Enter the minimal number of hours between wallpaper rotations [#{value_status} #{wruf.hours}]: "
wruf.hours = STDIN.readline.chomp.to_i

open(configuration_yaml, "w") { |file|
	file.write(wruf.to_yaml)
}