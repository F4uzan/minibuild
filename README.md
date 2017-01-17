# Minibuild

A tiny build script that compiles your ROM without hassle.

## Installation
--------------------

1.) Clone or download Minibuild's repository to your ROM source tree, alternatively, you can also use repo:

	<project path="minibuild" name="F4uzan/minibuild" remote="github" />

With remote GitHub being:

	  <remote  name="github"
           fetch="https://github.com/" />

2.) Run install.sh, located in Minibuild folder using bash:

	bash install.sh

3.) Follow the instructions and setup Minibuild for the first time
4.) Minibuild should now be copied to the root of your ROM source as file named "build.sh"
5.) Execute build.sh using bash:

	bash build.sh <commands> <parameters> <device>

Detailed help can be seen using the help command:

	bash build.sh help

6.) Enjoy!

## Reporting bugs & submitting patches
--------------------

I accept bug reports and patches, just use GitHub to report them, using "Pull Request" for patches and "Issues" for bug reports. Do note that this project is a simple project meant as an experiment, so bugs and missing features should be expected!

## Credits
--------------------

- mikecriggs for "fuckjack" script
- Some peeps at Stackoverflow, of course