#require 'rubygems'
require 'erb'
#require 'quick_magick'

class Chronoplan
	# Constants
	RADIUS = { 0 => 54, 1 => 72, 2 => 90, -1 => 36 }
        CENTERX=107
        CENTERY=102
        INNER_RADIUS = RADIUS[-1]
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
        TEMPLATE = %q{
            push graphic-context
                stroke 'none'
                fill '<%= rgba_string %>'
                path 'M <%= CENTERX %> <%= CENTERY %>
                      m <%=  INNER_RADIUS * Math.cos(start_arc_time) %>
                        <%= -INNER_RADIUS * Math.sin(start_arc_time) %>
                      l <%=  (outer_radius-INNER_RADIUS) * Math.cos(start_arc_time) %>
                        <%= -(outer_radius-INNER_RADIUS) * Math.sin(start_arc_time) %>
                      a <%= outer_radius %>,<%= outer_radius %> 0
                        <%= (start_arc_time - end_arc_time < Math::PI) ? '0' : '1' %>,1
                        <%= outer_radius * (Math.cos(end_arc_time) - Math.cos(start_arc_time)) %>,
                        <%= -outer_radius * (Math.sin(end_arc_time) - Math.sin(start_arc_time)) %>
                      l <%=  (INNER_RADIUS-outer_radius) * Math.cos(end_arc_time) %>
                        <%= -(INNER_RADIUS-outer_radius) * Math.sin(end_arc_time) %>
                      a <%= INNER_RADIUS %>,<%= INNER_RADIUS %> 0
                        <%= (start_arc_time - end_arc_time < Math::PI) ? '0' : '1' %>,0
                        <%=  INNER_RADIUS * (Math.cos(start_arc_time) - Math.cos(end_arc_time)) %>,
                        <%= -INNER_RADIUS * (Math.sin(start_arc_time) - Math.sin(end_arc_time)) %>
                      z'
            pop graphic-context
        }

	def initialize(input_file)
		@input_file = input_file	
	end

	def process
		# puts "Processing '#{@input_file}'."
		# image = QuickMagick::Image.read("#{ROOT}/images/Chronodex-trim.png").first

                puts "push graphic-context"
                puts "viewbox 0 0 214 204"
                templ = ERB.new(TEMPLATE)
		File.foreach(@input_file) do |line|
			parsed = line.split(";").map { |tmp| tmp.strip }
			start_arc_time = -Math::PI / 180 * parsed[0].to_f
			end_arc_time   = -Math::PI / 180 * parsed[1].to_f
			rgba_string = parsed[2]

			outer_radius_index = (parsed[0].to_f.modulo(90) / 30).floor
                        outer_radius = RADIUS[outer_radius_index]
                        puts templ.result(binding)
		end
                puts "pop graphic-context"
	end
end # class
