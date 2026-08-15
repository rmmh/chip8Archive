mato8
=====
Mato8 is an implementation of the classic snake game for CHIP-8. You should
run mato8 at a speed of at least 900 IPS for the intended experience.

Controls
--------
	      2 up
	left 4 6 right
	      8 down

NOTE: These are the CHIP-8 keys. Your implementation may map them to other
keys, e.g. 2 q e s.

Building
--------
Mato8 is meant to be built with [C-Octo](https://github.com/JohnEarnest/c-octo).

Running
-------
Mato8 is tested to work with [Octo](https://johnearnest.github.io/Octo/),
[C-Octo](https://github.com/JohnEarnest/c-octo),
[wernsey's chip8](https://github.com/wernsey/chip8), and
[sipsi-8](https://ahti.space/git/nortti/sipsi-8). Wernsey's Chip8 does not
support audio and draws pixels at the edges of the screen at the wrong
size. Sipsi-8 by default runs the game too slow, but you can tell it to run
it at 900 IPS.

	octo-run mato8.ch8
	chip8 mato8.ch8
	sipsi-8.py mato8.ch8 900

License
-------
Mato8 is released under CC0 1.0.
