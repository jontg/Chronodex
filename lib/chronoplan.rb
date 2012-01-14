require 'rubygems'
require 'quick_magick'

class Chronoplan
	# Constants
	RADIUS = { 0 => 54, 1 => 72, 2 => 90, -1 => 36 }
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory

	def initialize(input_file)
		@input_file = input_file	
	end

	def process
		puts "Processing '#{@input_file}'."

		image = QuickMagick::Image.read("#{ROOT}/images/Chronodex-trim.png").first
		overlay = QuickMagick::Image.solid(image.width, image.height)

		overlay.append_to_operators("transparent", "white")
		overlay.append_to_operators("stroke", "none")

		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = parsed[0].to_f
			end_arc_time   = parsed[1].to_f
			rgba_string = parsed[2]

			overlay.append_to_operators("fill", rgba_string)
			outer_radius   = (start_arc_time.modulo(90) / 30).floor

			box  = [107 - RADIUS[outer_radius],
			        102 - RADIUS[outer_radius],
			        107 + RADIUS[outer_radius],
			        102 + RADIUS[outer_radius]]

			cone = [107, 102,
			       (107+(RADIUS[outer_radius] - 0.5) * Math.cos(Math::PI / 180 * start_arc_time)),
			       (102+(RADIUS[outer_radius] - 0.5) * Math.sin(Math::PI / 180 * start_arc_time)),
			       (107+(RADIUS[outer_radius] - 0.5) * Math.cos(Math::PI / 180 * end_arc_time)),
			       (102+(RADIUS[outer_radius] - 0.5) * Math.sin(Math::PI / 180 * end_arc_time))]

			overlay.draw_arc(box[0], box[1], box[2], box[3], start_arc_time, end_arc_time)
			overlay.draw_polygon(cone)
		end
		overlay.display

		overlay.draw_image("Dst_Out", 0, 0, 0, 0, "#{ROOT}/images/Hole.png")
		overlay.convert("OVERLAY.png")

		image.draw_image("Over",0,0,0,0,"OVERLAY.png")
		puts image.command_line
		image.convert("output.png")
	end
end # class
