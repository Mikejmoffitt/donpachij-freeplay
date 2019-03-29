; AS configuration and original binary file to patch over
	CPU 68000
	PADDING OFF
	ORG		$000000
	BINCLUDE	"prg.orig"

; Free space to put new routines
ROM_FREE = $043C00

; Port definitions and useful RAM values
;INPUT_P1 = $101254
;INPUT_P2 = $101256

; 0x3 for 1P free play, 0xC for 2P free play
COINAGE_CFG = $101287

; # credits inserted; CRED_COUNT+2 shadows it to detect changes
CRED_COUNT = $10139A

; Game state tables
SC_STATE = $1018EC

; State table values match ESP Ra.De. exactly
S_INIT        = $0
S_TITLE       = $1
S_HISCORE     = $2
S_DEMOSTART   = $3
S_TITLE_START = $4
S_DEMO        = $5
S_INGAME_P2   = $6
S_INGAME_P1   = $7
S_CONTINUE    = $8
S_CHARSEL     = $B
S_CAVESC      = $C
S_ATLUSSC     = $D

; Checksum disable
checksum_disable:
	ORG	$03429A
	bra	$0342A8

; Macro for checking free play ----------------------------
FREEPLAY macro
	move.l	d1, -(sp)
	move.b	(COINAGE_CFG).l, d1
	andi.b	#$F0, d1
	cmpi.b	#$30, d1 ; Check if 1P freeplay enabled
	beq	.freeplay_is_enabled
	cmpi.b	#$C0, d1 ; Check if 2P freeplay enabled
	beq	.freeplay_is_enabled
	cmpi.b	#$F0, d1 ; Check if both freeplay enabled
	beq	.freeplay_is_enabled
	bra	+

.freeplay_is_enabled:
	move.l	(sp)+, d1
	ENDM

POST macro
	move.l	(sp)+, d1
	ENDM

; Menu stuff ---------------------------------------------

; replace 3 coins 1 play setting
menu_labels:
	ORG	$0024BD
	DC.B	"     FREE PLAY      "
	ORG	$0024FF
	DC.B	"     FREE PLAY      "
	ORG	$002599
	DC.B	"     FREE PLAY      "

; Credit injection ---------------------------------------
credit_injection:
	ORG	$00CBDA
	jmp	credit_injection_override

; In-game "Insert Coin" ----------------------------------
ingame_insert_coin_text:
	ORG	$00450C
	jmp	ingame_insert_coin_text_override

; Ship select screen -------------------------------------
select_p1_press_start:
	ORG	$031B26
	jmp	select_p1_press_start_override

select_p2_press_start:
	ORG	$031788
	jmp	select_p2_press_start_override

select_p1_credit_text:
	ORG	$031AF6
	jmp	select_p1_credit_text_override

select_p2_credit_text:
	ORG	$031758
	jmp	select_p2_credit_text_override

; Attract credit count -----------------------------------
credit_demo_count:
	ORG	$3376
	jmp	credit_demo_count_draw_override

credit_demo_label:
	ORG	$335A
	jmp	credit_demo_label_draw_override
	
credit_attract_count:
	ORG	$32F6
	jmp	credit_attract_count_override

credit_attract_label:
	ORG	$32DA
	jmp	credit_attract_label_override

; New Routines ------------------------------------------
	ORG	ROM_FREE

	DC.B	"DonPachi Free Play patch by Michael Moffitt"
	DC.B	0

	.align	2
credit_injection_override:
	FREEPLAY
	move.w	#9, ($10139A).l
	move.w	#9, ($10139C).l
	btst	#5, ($101398 + 1).l
	jmp	($00CBE2).l

/	POST
.resume
	btst	#5, ($101398 + 1).l
	jmp	($00CBE2).l

ingame_insert_coin_text_override:
	FREEPLAY
	jmp	($004530).l

/	POST
	move.w	$1018AA, d2
	jmp	($004512).l

select_p1_credit_text_override:
	FREEPLAY
	jmp	($031B0C).l

/	POST
	movea.l	#$40057C, a0
	jmp	($031AFC).l

select_p2_credit_text_override:
	FREEPLAY
	jmp	($03176E).l

/	POST
	movea.l	#$401010, a0
	jmp	($03175E).l

select_p1_press_start_override:
	FREEPLAY
	move.w	d2, $5C(a6)
	move.w	#$0000, $5E(a6)
	jmp	($031E9A).l

/	POST
	cmp.w	(a1), d4
	bls	.post ; if not, don't change mapping
	move.w	#$385B, d2
.post:
	jmp	($031B2E).l

select_p2_press_start_override:
	FREEPLAY
	move.w	d2, $58(a6)
	move.w	#$0000, $5A(a6)
	jmp	($031AB6).l

/	POST
	cmp.w	(a1), d4 ; Is credit count >= join cost?
	bls	.no_start ; if not, don't change mapping
	move.w	#$385B, d2 ; Select "Press Start" mapping
.no_start:
	jmp	($031790).l
	

credit_demo_count_draw_override:
	FREEPLAY
	rts

/	POST
	movea.l	#$401310, a0
	jmp	($00337C).l

credit_demo_label_draw_override:
	FREEPLAY
	rts

/	POST
	move.w	#1, ($10139E).l
	jmp	($003362).l

credit_attract_count_override:
	FREEPLAY
	rts

/	POST
	move.l	#$401308, a0
	jmp	($0032FC).l

credit_attract_label_override:
	FREEPLAY
	rts

/	POST
	move.w	#1, ($10139E).l
	jmp	($0032E2).l
