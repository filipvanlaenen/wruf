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
# Initializes a directory from which WRUF can be run.
# The directory from which WRUF will be run, must be the first parameter of the script.
#

require 'yaml'
require 'wruf_settings'

local_wruf_dir = File.expand_path(ARGV[0])
settings_yaml = File.join(local_wruf_dir, 'wruf.yaml')

if (File.exist?(settings_yaml))
	value_status = 'current'
	settings = WrufSettings.load(settings_yaml)
else
	value_status = 'default'
	settings = WrufSettings.new
	settings.dimensions = [1280, 800]
	settings.tolerance = 0.2
	settings.hours = 24
end

print "Enter the minimal width for the wallpaper photo [#{value_status} #{settings.dimensions[0]}]: "
width = STDIN.readline.chomp.to_i
if (width == 0)
	width = settings.dimensions[0]
end

print "Enter the minimal height for the wallpaper photo [#{value_status} #{settings.dimensions[1]}]: "
height = STDIN.readline.chomp.to_i
if (height == 0)
	height = settings.dimensions[1]
end

settings.dimensions = [width, height]

print "Enter the photo size tolerance [0-100, #{value_status} #{(settings.tolerance * 100).to_i}]: "
tolerance = STDIN.readline.chomp.to_i
if (tolerance < 1 || tolerance > 100)
	tolerance = 0.2
else
	tolerance = tolerance.to_f / 100
end
puts "Registering a tolerance of #{(tolerance * 100).to_i}%."

settings.tolerance = tolerance

print "Enter the minimal number of hours between wallpaper rotations [#{value_status} #{settings.hours}]: "
hours = STDIN.readline.chomp.to_i
if (hours != 0)
	settings.hours = hours
end

settings.holidays_options = [:be_nl, :no, :observed]

open(settings_yaml, "w") { |file|
	file.write(settings.to_yaml)
}
