# Command-line Chronodex image generation
This was put together to automatically generate coloring for [Chronodex][].
Example 

## Installation
This ruby script is a slim wrapper around QuickMagick, which are the python
extensions to work with [ImageMagick][].  Be sure to install [ImageMagick][]
(and ruby!) before tring to run this.

Suggestions for making installation, usage and usability more general is
greatly appreciated!

## Execution
Generate images

	bin/chronoplan example/schedule_sample.txt

Which generates a transparent overlay ("OVERLAY.png") and the final image
("output.png").

## Formatting
Each line of the input file represents one wedge of the [Chronodex][].  The
parameters are semi-colon delimited (';'), and are:

1. Start 'time' of the task (in degrees).
2. End 'time' of the task (in degrees).
3. [Color][] of the wedge, a format that ImageMagick understands.
4. Name of the task (optional).

An example input file can be found at [Example][].

## Credits
Inspired by [Scription](http://scription.typepad.com)'s amazing [Chronodex][].
I wanted to put together a small tool to generate these overlays based on a
simple text input.

[ImageMagick]: http://www.imagemagick.org/
[Chronodex]: http://scription.typepad.com/blog/2011/11/scription-chronodex-weekly-planner-2012-free-download-with-the-cost-of-a-prayer.html
[Color]: http://www.imagemagick.org/script/color.php
[Example]: https://github.com/jontg/Chronodex/blob/master/example/schedule_sample.txt
