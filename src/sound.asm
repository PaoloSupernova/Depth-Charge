// ============================================================================
// SOUND MODULE
// SID music player and sound effects engine
// ============================================================================

// SID Registers
.const SID_FREQ_LO1    = $D400
.const SID_FREQ_HI1    = $D401
.const SID_PW_LO1      = $D402
.const SID_PW_HI1      = $D403
.const SID_CTRL1       = $D404
.const SID_AD1         = $D405
.const SID_SR1         = $D406

.const SID_FREQ_LO2    = $D407
.const SID_FREQ_HI2    = $D408
.const SID_PW_LO2      = $D409
.const SID_PW_HI2      = $D40A
.const SID_CTRL2       = $D40B
.const SID_AD2         = $D40C
.const SID_SR2         = $D40D

.const SID_FREQ_LO3    = $D40E
.const SID_FREQ_HI3    = $D40F
.const SID_PW_LO3      = $D410
.const SID_PW_HI3      = $D411
.const SID_CTRL3       = $D412
.const SID_AD3         = $D413
.const SID_SR3         = $D414

.const SID_FC_LO       = $D415
.const SID_FC_HI       = $D416
.const SID_RES_FILT    = $D417
.const SID_MODE_VOL    = $D418

// Waveform bits
.const WAVE_NOISE      = $80
.const WAVE_PULSE      = $40
.const WAVE_SAW        = $20
.const WAVE_TRI        = $10
.const WAVE_TEST       = $08
.const WAVE_RING       = $04
.const WAVE_SYNC       = $02
.const WAVE_GATE       = $01

// Sound effect state
.var sfx_active        = $C300
.var sfx_type          = $C301
.var sfx_counter       = $C302
.var music_position    = $C303
.var music_counter     = $C304

// Sound effect types
.const SFX_NONE        = 0
.const SFX_TORPEDO     = 1
.const SFX_EXPLOSION   = 2
.const SFX_HIT         = 3
.const SFX_OXYGEN      = 4

// ============================================================================
// INITIALIZE SOUND
// ============================================================================

init_sound:
    // Clear all SID registers
    ldx #0
    lda #0
clear_sid:
    sta $D400,x
    inx
    cpx #25
    bcc clear_sid
    
    // Set volume to maximum
    lda #$0F
    sta SID_MODE_VOL
    
    // Configure filter
    lda #$00
    sta SID_FC_LO
    lda #$10
    sta SID_FC_HI
    lda #$70                    // Low-pass filter, resonance
    sta SID_RES_FILT
    
    // Initialize music variables
    lda #0
    sta music_position
    sta music_counter
    sta sfx_active
    
    rts

// ============================================================================
// PLAY MUSIC
// ============================================================================

play_music:
    // Simple music player - plays basic underwater ambience
    inc music_counter
    lda music_counter
    and #$1F                    // Update every 32 frames
    bne music_done
    
    // Voice 1: Bass rumble
    lda music_position
    and #$07
    tax
    lda bass_notes_lo,x
    sta SID_FREQ_LO1
    lda bass_notes_hi,x
    sta SID_FREQ_HI1
    
    lda #$00
    sta SID_PW_LO1
    lda #$08
    sta SID_PW_HI1
    
    lda #$88                    // Attack/Decay
    sta SID_AD1
    lda #$AA                    // Sustain/Release
    sta SID_SR1
    
    lda #WAVE_SAW | WAVE_GATE
    sta SID_CTRL1
    
    // Voice 2: Melody
    lda music_position
    and #$0F
    tax
    lda melody_notes_lo,x
    sta SID_FREQ_LO2
    lda melody_notes_hi,x
    sta SID_FREQ_HI2
    
    lda #$44
    sta SID_AD2
    lda #$66
    sta SID_SR2
    
    lda #WAVE_PULSE | WAVE_GATE
    sta SID_CTRL2
    
    // Voice 3: Atmosphere
    lda #$11
    sta SID_AD3
    lda #$AA
    sta SID_SR3
    
    lda #WAVE_TRI | WAVE_GATE
    sta SID_CTRL3
    
    inc music_position
    
music_done:
    rts

// ============================================================================
// PLAY SOUND EFFECTS
// ============================================================================

play_sfx:
    lda sfx_active
    beq sfx_done
    
    dec sfx_counter
    bne sfx_continue
    
    // Sound effect finished
    lda #0
    sta sfx_active
    rts
    
sfx_continue:
    // Update sound effect based on type
    lda sfx_type
    cmp #SFX_TORPEDO
    beq update_torpedo_sfx
    cmp #SFX_EXPLOSION
    beq update_explosion_sfx
    cmp #SFX_HIT
    beq update_hit_sfx
    
sfx_done:
    rts

// ============================================================================
// TORPEDO LAUNCH SOUND EFFECT
// ============================================================================

sfx_torpedo_launch:
    lda #SFX_TORPEDO
    sta sfx_type
    lda #1
    sta sfx_active
    lda #15                     // Duration
    sta sfx_counter
    
    // Voice 3: Swoosh sound
    lda #$20
    sta SID_FREQ_LO3
    lda #$08
    sta SID_FREQ_HI3
    
    lda #$22
    sta SID_AD3
    lda #$33
    sta SID_SR3
    
    lda #WAVE_NOISE | WAVE_GATE
    sta SID_CTRL3
    
    rts

update_torpedo_sfx:
    // Sweep frequency down
    lda SID_FREQ_HI3
    sec
    sbc #1
    sta SID_FREQ_HI3
    rts

// ============================================================================
// EXPLOSION SOUND EFFECT
// ============================================================================

sfx_explosion:
    lda #SFX_EXPLOSION
    sta sfx_type
    lda #1
    sta sfx_active
    lda #30                     // Duration
    sta sfx_counter
    
    // Voice 3: Explosion noise
    lda #$FF
    sta SID_FREQ_LO3
    lda #$0F
    sta SID_FREQ_HI3
    
    lda #$00                    // Instant attack
    sta SID_AD3
    lda #$88                    // Fast decay
    sta SID_SR3
    
    lda #WAVE_NOISE | WAVE_GATE
    sta SID_CTRL3
    
    rts

update_explosion_sfx:
    // Fade out noise
    lda SID_FREQ_HI3
    lsr
    sta SID_FREQ_HI3
    rts

// ============================================================================
// PLAYER HIT SOUND EFFECT
// ============================================================================

sfx_player_hit:
    lda #SFX_HIT
    sta sfx_type
    lda #1
    sta sfx_active
    lda #40                     // Duration
    sta sfx_counter
    
    // Voice 3: Harsh noise
    lda #$00
    sta SID_FREQ_LO3
    lda #$10
    sta SID_FREQ_HI3
    
    lda #$00
    sta SID_AD3
    lda #$99
    sta SID_SR3
    
    lda #WAVE_NOISE | WAVE_GATE
    sta SID_CTRL3
    
    rts

update_hit_sfx:
    // Warble effect
    lda sfx_counter
    and #$04
    beq hit_low
    lda #$12
    sta SID_FREQ_HI3
    rts
hit_low:
    lda #$0E
    sta SID_FREQ_HI3
    rts

// ============================================================================
// OXYGEN WARNING SOUND EFFECT
// ============================================================================

sfx_oxygen_warning:
    // Quick beep (doesn't interrupt music)
    // Only plays if no other SFX active
    lda sfx_active
    bne oxygen_skip
    
    lda #SFX_OXYGEN
    sta sfx_type
    lda #1
    sta sfx_active
    lda #5
    sta sfx_counter
    
    lda #$30
    sta SID_FREQ_LO3
    lda #$10
    sta SID_FREQ_HI3
    
    lda #$44
    sta SID_AD3
    lda #$44
    sta SID_SR3
    
    lda #WAVE_PULSE | WAVE_GATE
    sta SID_CTRL3
    
oxygen_skip:
    rts

// ============================================================================
// MUSIC DATA - Note frequency tables
// ============================================================================

// Bass notes (D minor scale, low octave)
bass_notes_lo:
    .byte $5B, $7C, $9F, $C5, $B6, $7C, $9F, $C5

bass_notes_hi:
    .byte $02, $02, $02, $02, $03, $02, $02, $02

// Melody notes (D minor pentatonic)
melody_notes_lo:
    .byte $B6, $7C, $9F, $C5, $F1, $C5, $9F, $7C
    .byte $B6, $F1, $C5, $9F, $B6, $C5, $9F, $7C

melody_notes_hi:
    .byte $03, $04, $04, $04, $04, $04, $04, $04
    .byte $03, $04, $04, $04, $03, $04, $04, $04
