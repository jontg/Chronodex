#require 'rubygems'
require 'erb'
#require 'quick_magick'

class Chronoplan
	# Constants
	RADIUS = { 0 => 108, 1 => 144, 2 => 180, 3 => 188, -1 => 72, -2 => 48 }
        CENTERX=190
        CENTERY=190
        INNER_RADIUS = RADIUS[-1]
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
        INTERIOR_ARC = ERB.new File.new("#{ROOT}/templates/basic_arc.erb").read
        BORDERS_ARC = ERB.new File.new("#{ROOT}/templates/border_arc.erb").read
        OUTSIDE_ARC = ERB.new File.new("#{ROOT}/templates/outside_arc.erb").read

	def initialize(input_file)
		@input_file = input_file	
	end

	def process
		# puts "Processing '#{@input_file}'."
		# image = QuickMagick::Image.read("#{ROOT}/images/Chronodex-trim.png").first

                puts "push graphic-context"
                puts "viewbox 0 0 380 380"
		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = -Math::PI / 180 * (parsed[0].to_f-180)
			end_arc_time   = -Math::PI / 180 * (parsed[1].to_f-180)
			rgba_string = parsed[2]

			outer_radius_index = (parsed[0].to_f.modulo(90) / 30).floor
                        outer_radius_index = -2 if parsed[0].to_f < 0
                        outer_radius_index = 3 if parsed[0].to_f >= 360
                        outer_radius = RADIUS[outer_radius_index]
                        puts INTERIOR_ARC.result(binding) if parsed[0].to_f < 360
                        puts OUTSIDE_ARC.result(binding) if parsed[0].to_f >= 360
                        rgba_start_line = rgba_string
                        rgba_end_line = rgba_string
                        rgba_inside_arc = rgba_string
                        rgba_outside_arc = rgba_string
                        puts BORDERS_ARC.result(binding) if parsed[0].to_f < 360
		end
                puts "pop graphic-context"
	end
end # class
