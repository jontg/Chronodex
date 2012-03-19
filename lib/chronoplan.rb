require 'rubygems'
require 'tempfile'
require 'erb'
require 'quick_magick'

class Chronoplan
	# Constants
        NINE_AM = Math::PI
        NINE_PM = 3.*Math::PI
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

        def parse
                temp_file = Tempfile.new(['ScheduleOverlay','.mvg'])
                puts temp_file.path
                temp_file.write File.new("#{ROOT}/images/Chronodex-v2.mvg").read

                temp_file.write "push graphic-context\n"
                temp_file.write "viewbox 0 0 380 380\n"
		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = time_to_radius(parsed[0])
			end_arc_time   = time_to_radius(parsed[1])
			rgba_string = parsed[2]

			outer_radius_index = radial_index(parsed[0])
                        outer_radius_index = -2 if start_arc_time < NINE_AM
                        outer_radius_index = 3 if start_arc_time >= NINE_PM
                        outer_radius = RADIUS[outer_radius_index]
                        outer_radius = RADIUS[-1]+20 if start_arc_time < NINE_PM
                        outer_radius = RADIUS[-1]-20 if start_arc_time < NINE_AM
                        outer_radius = RADIUS[3]-1 if start_arc_time >= NINE_PM

                        temp_file.write INTERIOR_ARC.result(binding) if start_arc_time < NINE_PM
                        temp_file.write OUTSIDE_ARC.result(binding) if start_arc_time >= NINE_PM
                        rgba_start_line = rgba_string
                        rgba_end_line = rgba_string
                        rgba_inside_arc = rgba_string
                        rgba_outside_arc = rgba_string
                        #temp_file.write BORDERS_ARC.result(binding) if start_arc_time < NINE_PM
		end
                temp_file.write "pop graphic-context\n"
                temp_file.close

                image = QuickMagick::Image.read(temp_file.path).first
                image.append_to_operators("background","none")
                image.append_to_operators("density","720")
                image.convert("output.png")
                temp_file.unlink
	end

	def process
                temp_file = Tempfile.new(['ScheduleOverlay','.mvg'])
                puts temp_file.path
                temp_file.write File.new("#{ROOT}/images/Chronodex-v2.mvg").read

                temp_file.write "push graphic-context\n"
                temp_file.write "viewbox 0 0 380 380\n"
		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = time_to_radius(parsed[0])
			end_arc_time   = time_to_radius(parsed[1])
			rgba_string = parsed[2]

			outer_radius_index = radial_index(parsed[0])
                        outer_radius_index = -2 if start_arc_time < NINE_AM
                        outer_radius_index = 3 if start_arc_time >= NINE_PM
                        outer_radius = RADIUS[outer_radius_index]
                        outer_radius = RADIUS[-1]+20 if start_arc_time < NINE_PM
                        outer_radius = RADIUS[-1]-20 if start_arc_time < NINE_AM
                        outer_radius = RADIUS[3]-1 if start_arc_time >= NINE_PM

                        temp_file.write INTERIOR_ARC.result(binding) if start_arc_time < NINE_PM
                        temp_file.write OUTSIDE_ARC.result(binding) if start_arc_time >= NINE_PM
                        rgba_start_line = rgba_string
                        rgba_end_line = rgba_string
                        rgba_inside_arc = rgba_string
                        rgba_outside_arc = rgba_string
                        #temp_file.write BORDERS_ARC.result(binding) if start_arc_time < NINE_PM
		end
                temp_file.write "pop graphic-context\n"
                temp_file.close

                image = QuickMagick::Image.read(temp_file.path).first
                image.append_to_operators("background","none")
                image.append_to_operators("density","720")
                image.convert("output.png")
                temp_file.unlink
	end

        def time_to_radius(time_string)
            hms = time_string.split(":")
            Math::PI/180*(hms[0].to_f*30.0+hms[1].to_f*0.5+hms[2].to_f*0.25/3.0 - 90.0)
        end

        def radial_index(time_string)
            hms = time_string.split(":")
            hms[0].to_i.modulo(3)
        end
end # class
