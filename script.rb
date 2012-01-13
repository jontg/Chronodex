require 'quick_magick'

radius = Hash[0 => 54,1 => 72,2 => 90,-1 => 36]

print "Processing ",ARGV[0],"\n"

image = QuickMagick::Image.read("images/Chronodex-trim.png").first
overlay = QuickMagick::Image.solid(image.width,image.height)

overlay.append_to_operators("transparent","white")
overlay.append_to_operators("stroke","none")
overlay.append_to_operators("fill","rgba(135, 206, 235,.5)")
IO.foreach(ARGV[0]) {|line|
    parsed=line.split(",").map{|tmp| tmp.strip}
    start_arc_time = Float(parsed[0])
    end_arc_time   = Float(parsed[1])
    outer_radius   = (start_arc_time.modulo(90.0) / 30.0).floor
    box = [107.0 - radius[outer_radius],102.0 - radius[outer_radius],107.0 + radius[outer_radius],102.0 + radius[outer_radius]]
    cone = [107, 102,
           (107+(radius[outer_radius]-0.7)*Math.cos(Math::PI/180*start_arc_time)),
           (102+(radius[outer_radius]-0.7)*Math.sin(Math::PI/180*start_arc_time)),
           (107+(radius[outer_radius]-0.7)*Math.cos(Math::PI/180*end_arc_time)),
           (102+(radius[outer_radius]-0.7)*Math.sin(Math::PI/180*end_arc_time))]

    overlay.draw_arc(box[0],box[1],box[2],box[3],start_arc_time,end_arc_time)
    overlay.draw_polygon(cone)
}
overlay.draw_image("Dst_Out",0,0,0,0,"images/Hole.png")
overlay.convert("OVERLAY.png")
image.draw_image("Over",0,0,0,0,"OVERLAY.png")
print image.command_line,"\n"
image.convert("output.png")
