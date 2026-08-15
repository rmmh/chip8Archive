; Mato8
; By nortti, 2023
; Snake game for CHIP-8
; Under Creative Commons Zero 1.0
; Assemble with c8asm (https://github.com/wernsey/chip8)

define frames_wait 5

define up_key 2
define down_key 8
define left_key 4
define right_key 6

define direction_up 0
define direction_down 6
define direction_left 12
define direction_right 18

define score_high_reg v5
define score_low_reg v6
define game_over_reg v7
define fruit_x_reg v8
define fruit_y_reg v9
define tail_x_reg va
define tail_y_reg vb
define head_direction_reg vc
define head_x_reg vd
define head_y_reg ve

start:
	cls
	ld game_over_reg, 0

	ld score_high_reg, 0
	ld score_low_reg, 0

	rnd head_x_reg, 63
	rnd head_y_reg, 31

	ld tail_x_reg, head_x_reg
	ld tail_y_reg, head_y_reg

	ld head_direction_reg, direction_right

	ld i, single_pixel
	drw head_x_reg, head_y_reg, 1

	call spawn_fruit

mainloop:
	ld v0, frames_wait
	ld dt, v0

	ld v1, head_direction_reg

	ld v0, up_key
	sknp v0
	call turn_up

	ld v0, down_key
	sknp v0
	call turn_down

	ld v0, left_key
	sknp v0
	call turn_left

	ld v0, right_key
	sknp v0
	call turn_right

	call move_snake

	; Wait until the frame timer hits zero
	mainloop_wait_loop:
		ld vf, dt
		se vf, 0
		jp mainloop_wait_loop

	sne game_over_reg, 0
	jp mainloop

game_over:
	ld v0, 20
	ld st, v0
	call wait

	call display_score

	ld v0, 30
	call wait

	ld v0, 20
	ld st, v0
	call wait

	ld v0, 30
	call wait

	ld v0, 20
	ld st, v0
	call wait

	jp start

display_score:
	cls

	ld i, score_high_bcd
	ld b, score_high_reg
	ld i, score_low_bcd
	ld b, score_low_reg

	ld i, score_low_bcd
	ld v2, [i]
	; v0 and v1 are zero, v2 is ones
	ld v3, v2
	ld i, score_high_bcd
	ld v2, [i]
	; v0 is thousands, v1 is hundreds, v2 is tens

	; Score is a four-digit number stored in v0 to v3
	ld v4, 0
	ld v5, 0
	ld f, v0
	drw v4, v5, 5

	add v4, 5
	ld f, v1
	drw v4, v5, 5

	add v4, 5
	ld f, v2
	drw v4, v5, 5

	add v4, 5
	ld f, v3
	drw v4, v5, 5

	ret

wait:
	ld dt, v0
	wait_loop:
		ld vf, dt
		se vf, 0
		jp wait_loop
	ret

spawn_fruit:
	rnd fruit_x_reg, 63
	rnd fruit_y_reg, 31

	ld i, single_pixel
	drw fruit_x_reg, fruit_y_reg, 1

	; Did we spawn succesfully?
	sne vf, 0
	ret

	; No, we spawned over the snake. Erase and try again
	ld i, single_pixel
	drw fruit_x_reg, fruit_y_reg, 1
	jp spawn_fruit

turn_up:
	; Don't allow 180° turns (which would kill the snake instantly)
	se v1, direction_down
	ld head_direction_reg, direction_up
	ret

turn_down:
	se v1, direction_up
	ld head_direction_reg, direction_down
	ret

turn_left:
	se v1, direction_right
	ld head_direction_reg, direction_left
	ret

turn_right:
	se v1, direction_left
	ld head_direction_reg, direction_right
	ret

move_snake:
	; Save the direction the snake is moving at head's location
	ld v0, head_x_reg
	ld v1, head_y_reg
	call direction_table_index
	ld v0, head_direction_reg
	ld [i], v0

	; Move the snake's head
	call unpack_direction
	add head_x_reg, v0
	ld v0, 63
	and head_x_reg, v0
	add head_y_reg, v1
	ld v0, 31
	and head_y_reg, v0

	; Draw head location and erase tail location
	ld i, single_pixel
	drw head_x_reg, head_y_reg, 1
	se vf, 0
	jp collision
	drw tail_x_reg, tail_y_reg, 1

	; Load the direction the snake was moving at tail's location
	ld v0, tail_x_reg
	ld v1, tail_y_reg
	call direction_table_index
	ld v0, [i]

	; Move the snake's tail
	call unpack_direction
	add tail_x_reg, v0
	ld v0, 63
	and tail_x_reg, v0
	add tail_y_reg, v1
	ld v0, 31
	and tail_y_reg, v0

	ret

direction_table_index:
	; v0 is the X coördinate, from 0 to 63, 00xxxxxx
	; v1 is the Y coördinate, from 0 to 31, 000yyyyy
	shl v0, v0
	shl v0, v0
	; v0 is the X coördinate shifted left by two, xxxxxx00
	ld v2, %11100000
	and v2, v0
	or v1, v2
	; v1 is combination of high 3 bits of X coördinate and the Y coördinate, xxxyyyyy
	ld v2, %00011100
	and v0, v2
	; v0 is the low 3 bits of the X coördinate shifted left by two, 000xxx00

	jp v0, direction_table_index_table
	direction_table_index_table:
		; 0
		ld i, #400
		jp direction_table_index_end

		; 1
		ld i, #500
		jp direction_table_index_end

		; 2
		ld i, #600
		jp direction_table_index_end

		; 3
		ld i, #700
		jp direction_table_index_end

		; 4
		ld i, #800
		jp direction_table_index_end

		; 5
		ld i, #900
		jp direction_table_index_end

		; 6
		ld i, #a00
		jp direction_table_index_end

		; 7
		ld i, #b00

direction_table_index_end:
	add i, v1
	ret

unpack_direction:
	jp v0, unpack_direction_table
	unpack_direction_table:
		; Up
		ld v0, 0
		ld v1, #ff
		ret

		; Down
		ld v0, 0
		ld v1, 1
		ret

		; Left
		ld v0, #ff
		ld v1, 0
		ret

		; Right
		ld v0, 1
		ld v1, 0
		ret

collision:
	se head_x_reg, fruit_x_reg
	jp tail_collision
	se head_y_reg, fruit_y_reg
	jp tail_collision

eat_fruit:
	; Jumping to collision skips tail moving code, so we get the snake
	; lengthening for free
	call increment_score

	ld v0, 1
	ld st, v0

	ld i, single_pixel
	drw fruit_x_reg, fruit_y_reg, 1
	jp spawn_fruit

increment_score:
	; Low register stores 0…9
	add score_low_reg, 1
	se score_low_reg, 10
	ret
	ld score_low_reg, 0
	add score_high_reg, 1
	ret

tail_collision:
	ld game_over_reg, 1
	ret

single_pixel: db #80
score_high_bcd: db 0, 0, 0
score_low_bcd: db 0, 0, 0
