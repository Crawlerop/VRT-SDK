FAMISTUDIO_CFG_EXTERNAL = 1
FAMISTUDIO_CFG_NTSC_SUPPORT = 1
FAMISTUDIO_CFG_DPCM_SUPPORT = 1
FAMISTUDIO_USE_VOLUME_TRACK = 1
FAMISTUDIO_USE_PITCH_TRACK = 1
FAMISTUDIO_USE_SLIDE_NOTES = 1
FAMISTUDIO_USE_VIBRATO = 1
FAMISTUDIO_USE_ARPEGGIO = 1
FAMISTUDIO_CFG_SFX_SUPPORT = 1
FAMISTUDIO_CFG_SFX_STREAMS = 1
FAMISTUDIO_CFG_C_BINDINGS = 1
FAMISTUDIO_DPCM_OFF = $F000

.define FAMISTUDIO_CA65_ZP_SEGMENT ZEROPAGE
.define FAMISTUDIO_CA65_RAM_SEGMENT BSS
.define FAMISTUDIO_CA65_CODE_SEGMENT CODE

.include "famistudio_ca65.s"

.export _music_play, _music_pause, _music_stop, _music_update, _set_music_speed
.export _sfx_play, _sample_play

;_music_init:
;    rts

.segment "STARTUP"
;.byte "FUSE APC"

_music_play:
    tax
	lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000 ;only uses A register
	txa ;song number
	jsr famistudio_music_play
	
	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000

_music_pause:
	tax
	lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000 ;only uses A register
	txa ;song number
	jsr famistudio_music_pause
	
	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000

_music_stop:
    lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000
	jsr famistudio_music_stop
	
	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000

_music_update:
    lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000
	jsr famistudio_update

	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000

;_sfx_init:
;    rts

_sfx_play:
	and #$03
	tax
	lda @sfxPriority,x
	tax
	
	lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000 ;only uses A register
	
	jsr popa ;a = sound
	;x = channel offset
	jsr famistudio_sfx_play
	
	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000
	;rts
@sfxPriority:
	.byte FAMISTUDIO_SFX_CH0, FAMISTUDIO_SFX_CH1, FAMISTUDIO_SFX_CH2, FAMISTUDIO_SFX_CH3

_sample_play:
    tax
	lda BP_BANK_8000 ;save current prg bank
	pha
	lda #SOUND_BANK
	jsr _set_prg_8000 ;only uses A register
	txa ;song number
	jsr famistudio_sfx_sample_play
	
	pla
	sta BP_BANK_8000 ;restore prg bank
	jmp _set_prg_8000

_set_music_speed:
    sta famistudio_song_speed
    rts