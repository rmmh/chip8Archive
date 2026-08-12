## Tick

<img src="recording.gif" width="600" alt="Icon preview">

This is a simple game developed for a standard Chip-8 machine.
The goal of the game is to press the `Z` button when the **circle** is inside or very
near the **square** in the middle. If you succeed, then the beeping sound will play, and you will get a score point. The more points you get, the more difficult the game gets. If you press `Z` in the wrong moment, your score will become 0.

To play this game, the only thing you need is a basic **Chip-8 interpreter**. The game relies on the standard **Chip-8 quirks**, which are the following:

* VF Reset - On
* Memory On
* Display Wait - On
* Clipping - Off
* Shifting - Off
* Jumping - Off

To make this game, I decided not to use the **Octo assembler**, but to instead create a custom script that compiles the Chip-8 instructions from `.txt` directly to `.ch8`.
I did it because I wanted to have full control over each instruction and still have features like comments and address labels available.
