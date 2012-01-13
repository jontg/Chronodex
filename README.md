# Command-line Chronodex image generation
This was put together to automatically generate coloring for [Chronodex][].

## Installation
Make sure you have ruby and libpng installed.  Once you have done so, install
the QuickMagick gem as:

	sudo gem install quick_magick

This gem is a slim wrapper around ImageMagick, which is used to composite and
generate the resulting images.

## Execution
Generate images

	ruby script.rb example_input

Which generates a transparent overlay ("OVERLAY.png") and the final image
("output.png").

## Formatting
Each line of the input file represents one wedge of the [Chronodex][].  The
parameters are semi-colon delimited (';'), and are:
1. Start 'time' of the task (in degrees).
2. End 'time' of the task (in degrees).
3. [Color][] of the wedge, a format that ImageMagick understands.
4. Name of the task (optional).

## Credits
Inspired by [Scription](http://scription.typepad.com)'s [Chronodex][].  I wanted
to put together a small tool to generate these overlays based on a simple text
input.

[Chronodex]: http://scription.typepad.com/blog/2011/11/scription-chronodex-weekly-planner-2012-free-download-with-the-cost-of-a-prayer.html
[Color]: http://www.imagemagick.org/script/color.php
