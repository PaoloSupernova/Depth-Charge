// ============================================================================
// SCROLLING MODULE
// Horizontal scrolling engine and level loading
// ============================================================================

.var scroll_position    = $C200  // Current scroll position in level
.var scroll_fine        = $C201  // Fine scroll value (0-7)
.var level_column       = $C202  // Current column in level data

// ============================================================================
// UPDATE SCROLL
// ============================================================================

update_scroll:
    // Decrement fine scroll
    lda scroll_fine
    sec
    sbc #SCROLL_SPEED
    sta scroll_fine
    
    // Check if we need coarse scroll
    bmi do_coarse_scroll
    
    // Update VIC-II scroll register
    ora #$10                    // Keep multicolor bit set
    sta VIC_CTRL2
    rts

do_coarse_scroll:
    // Reset fine scroll
    lda #7
    sta scroll_fine
    
    // Perform coarse scroll (shift screen left)
    jsr coarse_scroll
    
    // Load new column
    jsr load_new_column
    
    // Update scroll position
    inc scroll_position
    
    // Update VIC-II
    lda scroll_fine
    ora #$10
    sta VIC_CTRL2
    
    rts

// ============================================================================
// COARSE SCROLL - Shift screen left by one character
// ============================================================================

coarse_scroll:
    // This is a simplified version - shifts each row left
    // In practice, you'd unroll this for speed
    
    ldx #0                      // Row counter
scroll_row_loop:
    ldy #0                      // Column counter
    
scroll_col_loop:
    // Calculate screen address: row * 40 + column
    txa
    jsr multiply_by_40          // Result in ZP_TEMP1/2
    
    // Source: column + 1
    tya
    clc
    adc #1
    clc
    adc ZP_TEMP1
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #0
    sta ZP_TEMP2
    
    // Load from source (column+1)
    lda ZP_TEMP1
    clc
    adc #<SCREEN_RAM
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #>SCREEN_RAM
    sta ZP_TEMP2
    
    ldy #0
    lda (ZP_TEMP1),y
    pha
    
    // Destination: column
    txa
    jsr multiply_by_40
    tya
    clc
    adc ZP_TEMP1
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #0
    sta ZP_TEMP2
    
    lda ZP_TEMP1
    clc
    adc #<SCREEN_RAM
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #>SCREEN_RAM
    sta ZP_TEMP2
    
    pla
    ldy #0
    sta (ZP_TEMP1),y
    
    // Next column
    iny
    cpy #39                     // 39 columns (leave rightmost for new data)
    bcc scroll_col_loop
    
    // Next row
    inx
    cpx #25                     // 25 rows
    bcc scroll_row_loop
    
    rts

multiply_by_40:
    // Multiply A by 40, result in ZP_TEMP1 (lo) and ZP_TEMP2 (hi)
    // 40 = 32 + 8
    sta ZP_TEMP1
    lda #0
    sta ZP_TEMP2
    
    // Multiply by 8 (shift left 3 times)
    lda ZP_TEMP1
    asl
    rol ZP_TEMP2
    asl
    rol ZP_TEMP2
    asl
    rol ZP_TEMP2
    sta ZP_TEMP1                // Now ZP_TEMP1:2 = A * 8
    
    // Multiply by 32 (shift original left 5 times)
    txa
    asl
    asl
    asl
    asl
    asl
    
    // Add A*8 + A*32 = A*40
    clc
    adc ZP_TEMP1
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #0
    sta ZP_TEMP2
    
    rts

// ============================================================================
// LOAD NEW COLUMN
// ============================================================================

load_new_column:
    // Load a new column from level data into rightmost screen column
    // This is simplified - in a real game, this would read from level data tables
    
    ldy #0
load_column_loop:
    // Generate simple pattern based on Y position
    tya
    cmp #3
    bcc column_top              // Top rows (HUD area)
    cmp #23
    bcs column_bottom           // Bottom rows (info bar)
    
    // Gameplay area - water gradient
    lsr
    lsr
    clc
    adc #$A0                    // Water tile characters
    jmp store_column_char
    
column_top:
    lda #$20                    // Space
    jmp store_column_char
    
column_bottom:
    lda #$20                    // Space
    
store_column_char:
    // Store at rightmost column (column 39)
    // Calculate address: row * 40 + 39
    tya
    pha
    jsr multiply_by_40
    
    lda ZP_TEMP1
    clc
    adc #39
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #0
    sta ZP_TEMP2
    
    lda ZP_TEMP1
    clc
    adc #<SCREEN_RAM
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #>SCREEN_RAM
    sta ZP_TEMP2
    
    pla
    tay
    
    // Get the character to draw
    lda ZP_FRAME_COUNTER
    and #$07
    clc
    adc #$A0                    // Water animation
    
    ldy #0
    sta (ZP_TEMP1),y
    
    iny
    cpy #25
    bcc load_column_loop
    
    rts

// ============================================================================
// LOAD LEVEL DATA
// ============================================================================

load_level:
    // Initialize level based on ZP_LEVEL
    lda #0
    sta scroll_position
    sta scroll_fine
    sta level_column
    
    // Reset spawn system
    sta spawn_counter
    sta spawn_index
    
    // Clear all enemies
    ldx #0
clear_enemies:
    lda #0
    sta enemy_active,x
    inx
    cpx #MAX_ENEMIES
    bcc clear_enemies
    
    // Fill initial screen with level data
    jsr fill_initial_screen
    
    rts

fill_initial_screen:
    // Fill screen with starting level tiles
    ldx #0
fill_row:
    ldy #0
fill_col:
    // Calculate screen address
    txa
    pha
    jsr multiply_by_40
    tya
    clc
    adc ZP_TEMP1
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #0
    sta ZP_TEMP2
    
    lda ZP_TEMP1
    clc
    adc #<SCREEN_RAM
    sta ZP_TEMP1
    lda ZP_TEMP2
    adc #>SCREEN_RAM
    sta ZP_TEMP2
    
    // Determine tile based on position
    pla
    tax
    
    cpx #3
    bcc fill_hud_top
    cpx #23
    bcs fill_hud_bottom
    
    // Water area
    lda #$A0
    jmp fill_store
    
fill_hud_top:
    lda #$20                    // Space
    jmp fill_store
    
fill_hud_bottom:
    lda #$20                    // Space
    
fill_store:
    pha
    ldy #0
    sta (ZP_TEMP1),y
    pla
    
    iny
    cpy #40
    bcc fill_col
    
    inx
    cpx #25
    bcc fill_row
    
    rts

// ============================================================================
// CHECK LEVEL STATUS
// ============================================================================

check_level_status:
    // Check if level is complete (simplified)
    lda scroll_position
    cmp #200                    // Level length threshold
    bcc level_not_done
    
    // Level complete
    lda #STATE_LEVEL_DONE
    sta ZP_GAME_STATE
    
level_not_done:
    rts
