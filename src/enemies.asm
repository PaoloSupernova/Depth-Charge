// ============================================================================
// ENEMIES MODULE
// Enemy AI, spawning, and behavior patterns
// ============================================================================

// Enemy Types
.const ENEMY_NONE       = 0
.const ENEMY_SHIP       = 1
.const ENEMY_SUB        = 2
.const ENEMY_MINE       = 3
.const ENEMY_AIRCRAFT   = 4
.const ENEMY_BOSS       = 5

.const MAX_ENEMIES      = 5

// Enemy data structure (8 bytes per enemy)
.label enemy_active       = $C100  // Active flag (5 bytes)
.label enemy_type         = $C105  // Enemy type (5 bytes)
.label enemy_x            = $C10A  // X position (5 bytes)
.label enemy_y            = $C10F  // Y position (5 bytes)
.label enemy_health       = $C114  // Health points (5 bytes)
.label enemy_state        = $C119  // AI state (5 bytes)
.label enemy_timer        = $C11E  // Timer for AI (5 bytes)
.label enemy_data         = $C123  // Extra data byte (5 bytes)

.label spawn_counter      = $C150  // Spawn timer
.label spawn_index        = $C151  // Current spawn table index

// ============================================================================
// SPAWN ENEMIES
// ============================================================================

spawn_enemies:
    // Increment spawn counter
    inc spawn_counter
    lda spawn_counter
    cmp #60                     // Spawn every ~1 second
    bcc spawn_done
    
    lda #0
    sta spawn_counter
    
    // Check current level spawn table
    lda ZP_LEVEL
    cmp #9
    bcc level_ok
    lda #8                      // Cap at level 8
level_ok:
    jsr get_spawn_pattern
    
spawn_done:
    rts

get_spawn_pattern:
    // Simple spawn pattern based on level
    // In a full implementation, this would read from level data tables
    
    // Find first inactive enemy slot
    ldx #0
find_slot:
    lda enemy_active,x
    beq spawn_enemy_at_slot
    inx
    cpx #MAX_ENEMIES
    bcc find_slot
    rts                         // No slots available
    
spawn_enemy_at_slot:
    // Spawn random enemy type based on level
    lda ZP_FRAME_COUNTER
    and #$03                    // Random 0-3
    cmp ZP_LEVEL
    bcs spawn_ship
    cmp #2
    beq spawn_mine
    cmp #3
    beq spawn_aircraft
    
spawn_ship:
    lda #ENEMY_SHIP
    jmp setup_enemy
    
spawn_mine:
    lda #ENEMY_MINE
    jmp setup_enemy
    
spawn_aircraft:
    lda #ENEMY_AIRCRAFT
    jmp setup_enemy
    
setup_enemy:
    sta enemy_type,x
    
    lda #1
    sta enemy_active,x
    
    lda #255                    // Start at right edge
    sta enemy_x,x
    
    // Random Y position based on type
    lda ZP_FRAME_COUNTER
    and #$7F
    clc
    adc #50
    sta enemy_y,x
    
    lda #3                      // Default health
    sta enemy_health,x
    
    lda #0
    sta enemy_state,x
    sta enemy_timer,x
    
    rts

// ============================================================================
// UPDATE ENEMIES
// ============================================================================

update_enemies:
    ldx #0
update_enemy_loop:
    lda enemy_active,x
    beq next_enemy
    
    // Update based on type
    lda enemy_type,x
    cmp #ENEMY_SHIP
    beq update_ship
    cmp #ENEMY_SUB
    beq update_sub
    cmp #ENEMY_MINE
    beq update_mine
    cmp #ENEMY_AIRCRAFT
    beq update_aircraft
    jmp next_enemy
    
update_ship:
    jsr ai_surface_ship
    jmp position_enemy_sprite
    
update_sub:
    jsr ai_enemy_sub
    jmp position_enemy_sprite
    
update_mine:
    jsr ai_mine
    jmp position_enemy_sprite
    
update_aircraft:
    jsr ai_aircraft
    jmp position_enemy_sprite
    
position_enemy_sprite:
    // Calculate sprite number (sprites 3-7 for enemies)
    txa
    clc
    adc #3
    tay
    
    // Set sprite position
    tya
    asl                         // Multiply by 2 for register offset
    tay
    lda enemy_x,x
    sta $D000,y                 // Sprite X
    lda enemy_y,x
    sta $D001,y                 // Sprite Y
    
    // Set sprite pointer
    txa
    clc
    adc #3
    clc
    adc #$FB                    // Screen RAM sprite pointers start at +$3F8
    tay
    lda enemy_type,x
    clc
    adc #(SPRITE_DATA/$40)+5    // Enemy sprites start after player/torpedo
    sta SCREEN_RAM,y
    
next_enemy:
    inx
    cpx #MAX_ENEMIES
    bcc update_enemy_loop
    
    rts

// ============================================================================
// AI ROUTINES
// ============================================================================

ai_surface_ship:
    // Move left with scroll (appears stationary)
    lda enemy_x,x
    sec
    sbc #SCROLL_SPEED
    sta enemy_x,x
    
    // Check if off screen
    cmp #5
    bcs ship_ai_continue
    lda #0
    sta enemy_active,x          // Deactivate
    rts
    
ship_ai_continue:
    // Drop depth charge periodically
    inc enemy_timer,x
    lda enemy_timer,x
    cmp #120                    // Every 2 seconds
    bcc ship_done
    
    lda #0
    sta enemy_timer,x
    // TODO: Spawn depth charge projectile
    
ship_done:
    rts

ai_enemy_sub:
    // Move left
    lda enemy_x,x
    sec
    sbc #2
    sta enemy_x,x
    
    // Sine wave vertical movement
    lda enemy_timer,x
    clc
    adc #2
    sta enemy_timer,x
    and #$1F
    tay
    lda sine_table,y
    clc
    adc enemy_y,x
    sta enemy_y,x
    
    // Check if off screen
    lda enemy_x,x
    cmp #5
    bcs sub_done
    lda #0
    sta enemy_active,x
    
sub_done:
    rts

ai_mine:
    // Stationary relative to water (moves left with scroll)
    lda enemy_x,x
    sec
    sbc #SCROLL_SPEED
    sta enemy_x,x
    
    // Bob up and down slightly
    inc enemy_timer,x
    lda enemy_timer,x
    and #$0F
    cmp #$08
    bcs mine_bob_down
    inc enemy_y,x
    jmp mine_check
mine_bob_down:
    dec enemy_y,x
    
mine_check:
    // Check if off screen
    lda enemy_x,x
    cmp #5
    bcs mine_done
    lda #0
    sta enemy_active,x
    
mine_done:
    rts

ai_aircraft:
    // Move left faster than scroll
    lda enemy_x,x
    sec
    sbc #3
    sta enemy_x,x
    
    // Stay above water (Y < 40)
    lda enemy_y,x
    cmp #40
    bcc aircraft_check
    lda #35
    sta enemy_y,x
    
aircraft_check:
    // Check if off screen
    lda enemy_x,x
    cmp #5
    bcs aircraft_done
    lda #0
    sta enemy_active,x
    
aircraft_done:
    rts

// ============================================================================
// ENEMY HIT HANDLING
// ============================================================================

enemy_hit:
    // X register contains enemy index
    dec enemy_health,x
    lda enemy_health,x
    bne hit_done
    
    // Enemy destroyed
    lda #0
    sta enemy_active,x
    
    // Add score based on enemy type
    lda enemy_type,x
    cmp #ENEMY_SHIP
    beq score_ship
    cmp #ENEMY_SUB
    beq score_sub
    cmp #ENEMY_MINE
    beq score_mine
    cmp #ENEMY_AIRCRAFT
    beq score_aircraft
    rts
    
score_ship:
    jsr add_score_100
    rts
    
score_sub:
    jsr add_score_100
    jsr add_score_100           // 150 points (simplified)
    rts
    
score_mine:
    // 50 points
    rts
    
score_aircraft:
    jsr add_score_100
    jsr add_score_100           // 200 points (simplified)
    rts
    
hit_done:
    rts

// ============================================================================
// DATA TABLES
// ============================================================================

sine_table:
    .byte 0, 1, 2, 3, 4, 5, 5, 5, 4, 3, 2, 1, 0, -1, -2, -3
    .byte -4, -5, -5, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 5, 5
