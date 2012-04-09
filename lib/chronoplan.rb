require 'rubygems'
require 'tempfile'
require 'erb'
require 'quick_magick'

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

	def process(entries)
		temp_file = Tempfile.new(['ScheduleOverlay','.mvg'])
		puts temp_file.path
		temp_file.write File.new("#{ROOT}/images/Chronodex-v2.mvg").read

		temp_file.write "push graphic-context\n"
		temp_file.write "viewbox 0 0 380 380\n"
		entries.map {|data|
			start_arc_time = data.start_arc
			end_arc_time   = data.end_arc
			rgba_string = data.color
			outer_radius = RADIUS[data.height]

			temp_file.write INTERIOR_ARC.result(binding) if start_arc_time < Chronodex::NINE_PM
			temp_file.write OUTSIDE_ARC.result(binding) if start_arc_time >= Chronodex::NINE_PM
			rgba_start_line = rgba_string
			rgba_end_line = rgba_string
			rgba_inside_arc = rgba_string
			rgba_outside_arc = rgba_string
			#temp_file.write BORDERS_ARC.result(binding) if start_arc_time < NINE_PM
		}
		temp_file.write "pop graphic-context\n"
		temp_file.close

		image = QuickMagick::Image.read(temp_file.path).first
		image.append_to_operators("background","none")
		image.append_to_operators("density","720")
		image.convert("output.png")
		temp_file.unlink
	end
end # class
