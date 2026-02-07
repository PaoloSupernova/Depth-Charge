// ============================================================================
// GRAPHICS MODULE
// Drawing routines and HUD updates
// ============================================================================

// HUD positions
.const HUD_SCORE_X     = 7
.const HUD_SCORE_Y     = 0
.const HUD_LIVES_X     = 20
.const HUD_LIVES_Y     = 0
.const HUD_OXYGEN_X    = 28
.const HUD_OXYGEN_Y    = 0

// Character codes
.const CHAR_HEART      = $53
.const CHAR_BLOCK_FULL = $A0
.const CHAR_BLOCK_HALF = $A1
.const CHAR_BLOCK_EMPTY = $20

// ============================================================================
// DRAW HUD
// ============================================================================

draw_hud:
    jsr draw_score
    jsr draw_lives
    jsr draw_oxygen
    jsr draw_level_info
    rts

// ============================================================================
// DRAW SCORE
// ============================================================================

draw_score:
    // Draw "SCORE: " label at top left
    ldx #0
    lda #HUD_SCORE_Y
    jsr calc_screen_addr
    
    ldx #0
draw_score_label:
    lda score_label,x
    beq draw_score_digits
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_score_label
    
draw_score_digits:
    // Convert BCD score to screen codes
    // High byte
    lda ZP_SCORE_HI
    lsr
    lsr
    lsr
    lsr
    ora #$30                    // Convert to screen code
    sta (ZP_TEMP1),y
    iny
    
    lda ZP_SCORE_HI
    and #$0F
    ora #$30
    sta (ZP_TEMP1),y
    iny
    
    // Middle byte
    lda ZP_SCORE_MID
    lsr
    lsr
    lsr
    lsr
    ora #$30
    sta (ZP_TEMP1),y
    iny
    
    lda ZP_SCORE_MID
    and #$0F
    ora #$30
    sta (ZP_TEMP1),y
    iny
    
    // Low byte
    lda ZP_SCORE_LO
    lsr
    lsr
    lsr
    lsr
    ora #$30
    sta (ZP_TEMP1),y
    iny
    
    lda ZP_SCORE_LO
    and #$0F
    ora #$30
    sta (ZP_TEMP1),y
    
    rts

score_label:
    .text "score:"
    .byte 0

// ============================================================================
// DRAW LIVES
// ============================================================================

draw_lives:
    lda #HUD_LIVES_Y
    ldx #HUD_LIVES_X
    jsr calc_screen_addr
    
    // Draw heart symbols for each life
    ldx ZP_LIVES
    beq no_lives
    
draw_life_loop:
    lda #CHAR_HEART
    sta (ZP_TEMP1),y
    iny
    dex
    bne draw_life_loop
    
no_lives:
    rts

// ============================================================================
// DRAW OXYGEN BAR
// ============================================================================

draw_oxygen:
    lda #HUD_OXYGEN_Y
    ldx #HUD_OXYGEN_X
    jsr calc_screen_addr
    
    // Draw "O2:" label
    lda #$0F                    // 'O'
    sta (ZP_TEMP1),y
    iny
    lda #$32                    // '2'
    sta (ZP_TEMP1),y
    iny
    lda #$3A                    // ':'
    sta (ZP_TEMP1),y
    iny
    
    // Calculate filled blocks (oxygen / 25 = number of blocks)
    lda ZP_PLAYER_OXYGEN
    lsr                         // Divide by 32 (approximate /25)
    lsr
    lsr
    lsr
    lsr
    tax                         // X = filled blocks
    
    // Draw oxygen bar (10 blocks total)
    ldy #3
draw_oxygen_bar:
    cpx #0
    beq draw_empty_oxygen
    lda #CHAR_BLOCK_FULL
    jmp store_oxygen_char
    
draw_empty_oxygen:
    lda #CHAR_BLOCK_EMPTY
    
store_oxygen_char:
    sta (ZP_TEMP1),y
    iny
    dex
    cpy #13                     // 10 blocks
    bcc draw_oxygen_bar
    
    rts

// ============================================================================
// DRAW LEVEL INFO (bottom bar)
// ============================================================================

draw_level_info:
    // Draw level number at bottom
    lda #24                     // Bottom row
    ldx #0
    jsr calc_screen_addr
    
    ldx #0
draw_level_label:
    lda level_label,x
    beq draw_level_num
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_level_label
    
draw_level_num:
    lda ZP_LEVEL
    ora #$30                    // Convert to screen code
    sta (ZP_TEMP1),y
    
    rts

level_label:
    .text "level:"
    .byte 0

// ============================================================================
// CALCULATE SCREEN ADDRESS
// Helper: A = row, X = column, result in ZP_TEMP1/2, Y = column
// ============================================================================

calc_screen_addr:
    stx ZP_TEMP2                // Save column
    
    // Multiply row by 40
    sta ZP_TEMP1
    lda #0
    sta ZP_TEMP2
    
    // A * 40 = A * 32 + A * 8
    lda ZP_TEMP1
    asl
    asl
    asl
    sta ZP_TEMP1                // A * 8
    
    lda ZP_TEMP1
    asl
    asl                         // A * 32
    clc
    adc ZP_TEMP1                // A * 40
    sta ZP_TEMP1
    
    // Add column offset
    ldx ZP_TEMP2
    txa
    clc
    adc ZP_TEMP1
    sta ZP_TEMP1
    lda #0
    adc #0
    sta ZP_TEMP2
    
    // Add screen base
    lda ZP_TEMP1
    clc
    adc #<SCREEN_RAM
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #>SCREEN_RAM
    sta ZP_TEMP2
    
    ldy #0
    rts

// ============================================================================
// TITLE SCREEN
// ============================================================================

update_title_screen:
    // Simple title screen display
    // In a full implementation, this would have animated graphics
    
    // Check if screen needs to be drawn
    lda ZP_FRAME_COUNTER
    bne title_animate
    
    // Draw title text
    jsr draw_title_text
    
title_animate:
    // Animate "PRESS FIRE" text
    lda ZP_FRAME_COUNTER
    and #$20
    bne title_done
    
    // Draw blinking text
    lda #12
    ldx #15
    jsr calc_screen_addr
    
    ldx #0
title_press_fire:
    lda press_fire_text,x
    beq title_done
    sta (ZP_TEMP1),y
    iny
    inx
    jmp title_press_fire
    
title_done:
    rts

draw_title_text:
    // Draw game title
    lda #8
    ldx #10
    jsr calc_screen_addr
    
    ldx #0
draw_title_loop:
    lda title_text,x
    beq title_text_done
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_title_loop
    
title_text_done:
    rts

title_text:
    .text "depth charge"
    .byte 0

press_fire_text:
    .text "press fire"
    .byte 0

check_start_game:
    // Check for fire button
    lda JOY_PORT2
    and #JOY_FIRE
    bne start_check_done
    
    // Start game
    lda #STATE_PLAYING
    sta ZP_GAME_STATE
    jsr load_level
    
start_check_done:
    rts

// ============================================================================
// PAUSE SCREEN
// ============================================================================

update_pause_screen:
    // Display "PAUSED" text
    lda #12
    ldx #17
    jsr calc_screen_addr
    
    ldx #0
draw_paused:
    lda paused_text,x
    beq pause_done
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_paused
    
pause_done:
    rts

paused_text:
    .text "paused"
    .byte 0

check_pause:
    // Check RUN/STOP key (simplified - check fire button)
    // In real implementation, would scan keyboard
    rts

check_unpause:
    // Check fire button to unpause
    lda JOY_PORT2
    and #JOY_FIRE
    bne unpause_done
    
    lda #STATE_PLAYING
    sta ZP_GAME_STATE
    
unpause_done:
    rts

// ============================================================================
// LEVEL COMPLETE SCREEN
// ============================================================================

update_level_done_screen:
    // Display "LEVEL COMPLETE" message
    lda #10
    ldx #12
    jsr calc_screen_addr
    
    ldx #0
draw_complete:
    lda complete_text,x
    beq complete_done
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_complete
    
complete_done:
    rts

complete_text:
    .text "level complete!"
    .byte 0

check_next_level:
    // Wait for fire button
    lda JOY_PORT2
    and #JOY_FIRE
    bne next_level_done
    
    // Advance to next level
    inc ZP_LEVEL
    lda ZP_LEVEL
    cmp #9
    bcc start_next_level
    lda #1                      // Loop back to level 1
    sta ZP_LEVEL
    
start_next_level:
    jsr load_level
    lda #STATE_PLAYING
    sta ZP_GAME_STATE
    
next_level_done:
    rts

// ============================================================================
// GAME OVER SCREEN
// ============================================================================

update_game_over_screen:
    // Display "GAME OVER" message
    lda #10
    ldx #15
    jsr calc_screen_addr
    
    ldx #0
draw_game_over:
    lda game_over_text,x
    beq game_over_done
    sta (ZP_TEMP1),y
    iny
    inx
    jmp draw_game_over
    
game_over_done:
    rts

game_over_text:
    .text "game over"
    .byte 0

check_restart:
    // Wait for fire button
    lda JOY_PORT2
    and #JOY_FIRE
    bne restart_done
    
    // Restart game
    jsr init_game
    lda #STATE_TITLE
    sta ZP_GAME_STATE
    
restart_done:
    rts

// ============================================================================
// LOAD CHARSET
// ============================================================================

load_charset:
    // In a full implementation, this would load custom character set
    // For now, we use the default charset
    rts
