#require 'rubygems'
require 'erb'
#require 'quick_magick'

class Chronoplan
	# Constants
	RADIUS = { 0 => 54, 1 => 72, 2 => 90, -1 => 36, -2 => 24}
        CENTERX=107
        CENTERY=102
        INNER_RADIUS = RADIUS[-1]
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
        BASIC_ARC = ERB.new File.new("#{ROOT}/templates/basic_arc.erb").read
        BORDERS_ARC = ERB.new File.new("#{ROOT}/templates/border_arc.erb").read

	def initialize(input_file)
		@input_file = input_file	
	end

	def process
		# puts "Processing '#{@input_file}'."
		# image = QuickMagick::Image.read("#{ROOT}/images/Chronodex-trim.png").first

                puts "push graphic-context"
                puts "viewbox 0 0 214 204"
		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = -Math::PI / 180 * parsed[0].to_f
			end_arc_time   = -Math::PI / 180 * parsed[1].to_f
			rgba_string = parsed[2]

			outer_radius_index = (parsed[0].to_f.modulo(90) / 30).floor
                        outer_radius = RADIUS[outer_radius_index]
                        #puts BASIC_ARC.result(binding)
                        rgba_start_line = 'none'
                        rgba_end_line = rgba_string
                        rgba_inside_arc = 'none'
                        rgba_outside_arc = rgba_string
                        puts BORDERS_ARC.result(binding)
		end
                puts "pop graphic-context"
	end
end # class
