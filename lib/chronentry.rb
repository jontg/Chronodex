module Chronodex
	NINE_AM = Math::PI
	NINE_PM = 3.*Math::PI

	class Data
		attr_reader :start_arc,:end_arc,:color,:height

		def initialize(start_arc, end_arc, color, height)
			@start_arc, @end_arc, @color, @height = start_arc, end_arc, color, height
		end
	end # class

	def Chronodex.time_to_radius(time_string)
		hms = time_string.split(":")
		Math::PI/180*(hms[0].to_f*30.0+hms[1].to_f*0.5+hms[2].to_f*0.25/3.0 - 90.0)
	end

	def Chronodex.radial_index(time_string)
		hms = time_string.split(":")
		hms[0].to_i.modulo(3)
	end

	def Chronodex.parse_from_strings(parsed)
		start_arc = Chronodex.time_to_radius(parsed[0])
		end_arc   = Chronodex.time_to_radius(parsed[1])
		color     = parsed[2]

		height = radial_index(parsed[0])
		height = -2 if start_arc < NINE_AM
		height = 3 if start_arc >= NINE_PM

		Data.new(start_arc, end_arc, color, height)
	end
end #module
