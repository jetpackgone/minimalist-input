## Minimalist Name Input - An RPG Maker VX Ace script

### About

The purpose of this script is to provide a simpler interface for inputting actor names and passwords in RPG Maker VX Ace, as the current interface contains too many characters that are unlikely to be necessary. Scripts for RPG Maker VX Ace are in Ruby (RGSS3).

Feel free to use and modify this script, and please credit me if you do.

There are two scripts in this repository
* `minimalist-name-input.txt` - v1.1
* `spirit-board-name-input.rb` - v1.2

`minimalist-name-input.txt` contains the classic look of the name input containing only capital letters displayed in straight rows.

`spirit-board-name-input.rb` contains a "spirit board" look and contains both capital letters and number. The letters are displayed in two parabolic rows, while the numbers are displayed in a straight row.

### Instructions

#### Viewing the Script
To view the script, look in `minimalist-name-input.txt` or `spirit-board-name-input.rb` located in this repository.

Alternatively, you can find the script inside the demo by opening up the demo's scripts and scrolling down to `Minimalist Name Input`. Replace this script with whatever version you wish to use.

#### Viewing the Demo

To view the demo, extract the `minimalist-name-input.zip` file from this repository and run the `Game.exe` application.

#### Using the Script

To add the script to your game, paste the script below Materials and above Main. This is also where the script is in the included demo. After doing this, whenever you run the event `Name Input Processing...`, the new interface should appear instead of the default one.

Note: Version 1.1 works best for names/passwords up to 8 letters long. Any longer than 8 letters results in incorrect positioning due to the width of the name input window. Version 1.2 works for names up to 16 characters long. I plan to combine both of these scripts in the near future so that the display between the classic and spirit-board can be toggled with a parameter.

![Minimalist Name Input](http://40.media.tumblr.com/86e6f3d5f0789def1789166b57dd9ad3/tumblr_noczdbMLWD1u02zbio1_500.png)
