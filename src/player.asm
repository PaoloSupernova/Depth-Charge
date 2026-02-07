// ============================================================================
// PLAYER CONTROL MODULE
// Handles player submarine movement, shooting, and collision
// ============================================================================

// Player state variables
.label player_x = $C000
.label player_y = $C001
.label player_dx = $C002          // Delta X (velocity)
.label player_dy = $C003          // Delta Y (velocity)
.label player_invincible = $C004  // Invincibility counter
.label player_anim_frame = $C005  // Animation frame (0-2)
.label player_torpedoes = $C006   // Active torpedoes count

// Torpedo data (2 torpedoes max)
.label torpedo1_active = $C010
.label torpedo1_x = $C011
.label torpedo1_y = $C012
.label torpedo2_active = $C013
.label torpedo2_x = $C014
.label torpedo2_y = $C015

// ============================================================================
// READ JOYSTICK AND UPDATE PLAYER
// ============================================================================

read_joystick:
    // Read joystick port 2
    lda JOY_PORT2
    sta ZP_TEMP1
    
    // Check if invincible (skip collision if so)
    lda player_invincible
    beq joy_continue
    dec player_invincible       // Decrement invincibility timer
    
joy_continue:
    lda ZP_TEMP1
    
    // Check UP
    and #JOY_UP
    bne check_down
    lda player_y
    cmp #30                     // Top boundary
    bcc check_down
    dec player_y
    
check_down:
    lda ZP_TEMP1
    and #JOY_DOWN
    bne check_left
    lda player_y
    cmp #200                    // Bottom boundary
    bcs check_left
    inc player_y
    
check_left:
    lda ZP_TEMP1
    and #JOY_LEFT
    bne check_right
    lda player_x
    cmp #24                     // Left boundary
    bcc check_right
    dec player_x
    
check_right:
    lda ZP_TEMP1
    and #JOY_RIGHT
    bne check_fire
    lda player_x
    cmp #280                    // Right boundary (approximate)
    bcs check_fire
    inc player_x
    
check_fire:
    lda ZP_TEMP1
    and #JOY_FIRE
    bne joy_done
    // Fire button pressed
    jsr fire_torpedo
    
joy_done:
    rts

// ============================================================================
// UPDATE PLAYER STATE
// ============================================================================

update_player:
    // Copy player position to sprite 0
    lda player_x
    sta $D000                   // Sprite 0 X position
    
    lda player_y
    sta $D001                   // Sprite 0 Y position
    
    // Handle X position > 255 (MSB)
    lda player_x
    cmp #255
    bcc no_msb
    lda $D010                   // Sprite X MSB register
    ora #$01                    // Set bit 0 for sprite 0
    sta $D010
    jmp update_anim
no_msb:
    lda $D010
    and #$FE                    // Clear bit 0
    sta $D010
    
update_anim:
    // Update animation frame (propeller spinning)
    inc ZP_FRAME_COUNTER
    lda ZP_FRAME_COUNTER
    and #$0F                    // Every 16 frames
    bne anim_done
    
    lda player_anim_frame
    clc
    adc #1
    cmp #3
    bcc store_frame
    lda #0
store_frame:
    sta player_anim_frame
    
    // Update sprite pointer based on animation frame
    asl                         // Multiply by 1 (sprites are sequential)
    clc
    adc #(SPRITE_DATA/$40)      // Base sprite pointer
    sta SCREEN_RAM+$3F8         // Sprite 0 pointer
    
anim_done:
    rts

// ============================================================================
// FIRE TORPEDO
// ============================================================================

fire_torpedo:
    // Check if we can fire (max 2 torpedoes)
    lda player_torpedoes
    cmp #MAX_TORPEDOES
    bcs fire_done               // Already at max
    
    // Check torpedo 1 slot
    lda torpedo1_active
    beq fire_torpedo1
    
    // Check torpedo 2 slot
    lda torpedo2_active
    beq fire_torpedo2
    
    // Both slots full
    jmp fire_done

fire_torpedo1:
    lda #1
    sta torpedo1_active
    lda player_x
    clc
    adc #24                     // Offset from player sprite
    sta torpedo1_x
    lda player_y
    sta torpedo1_y
    inc player_torpedoes
    jsr sfx_torpedo_launch
    jmp fire_done

fire_torpedo2:
    lda #1
    sta torpedo2_active
    lda player_x
    clc
    adc #24
    sta torpedo2_x
    lda player_y
    sta torpedo2_y
    inc player_torpedoes
    jsr sfx_torpedo_launch
    
fire_done:
    rts

// ============================================================================
// UPDATE BULLETS (TORPEDOES)
// ============================================================================

update_bullets:
    // Update torpedo 1
    lda torpedo1_active
    beq check_torpedo2
    
    // Move torpedo right
    lda torpedo1_x
    clc
    adc #4                      // Torpedo speed
    sta torpedo1_x
    
    // Check if off screen
    cmp #255
    bcs deactivate_torpedo1
    
    // Update sprite 1 position
    sta $D002                   // Sprite 1 X
    lda torpedo1_y
    sta $D003                   // Sprite 1 Y
    jmp check_torpedo2
    
deactivate_torpedo1:
    lda #0
    sta torpedo1_active
    dec player_torpedoes
    
check_torpedo2:
    // Update torpedo 2
    lda torpedo2_active
    beq bullets_done
    
    // Move torpedo right
    lda torpedo2_x
    clc
    adc #4
    sta torpedo2_x
    
    // Check if off screen
    cmp #255
    bcs deactivate_torpedo2
    
    // Update sprite 2 position
    sta $D004                   // Sprite 2 X
    lda torpedo2_y
    sta $D005                   // Sprite 2 Y
    jmp bullets_done
    
deactivate_torpedo2:
    lda #0
    sta torpedo2_active
    dec player_torpedoes
    
bullets_done:
    // Update sprite pointers for torpedoes
    lda torpedo1_active
    beq torp1_off
    lda #(SPRITE_DATA/$40)+3    // Torpedo sprite
    sta SCREEN_RAM+$3F9         // Sprite 1 pointer
    jmp check_torp2_sprite
torp1_off:
    lda #0                      // Disable by pointing to empty sprite
    sta SCREEN_RAM+$3F9
    
check_torp2_sprite:
    lda torpedo2_active
    beq torp2_off
    lda #(SPRITE_DATA/$40)+3
    sta SCREEN_RAM+$3FA         // Sprite 2 pointer
    rts
torp2_off:
    lda #0
    sta SCREEN_RAM+$3FA
    rts

// ============================================================================
// PLAYER HIT HANDLING
// ============================================================================

player_hit:
    // Check if invincible
    lda player_invincible
    bne hit_done
    
    // Lose a life
    dec ZP_LIVES
    
    // Play sound effect
    jsr sfx_player_hit
    
    // Set invincibility period
    lda #120                    // 2 seconds at 60fps
    sta player_invincible
    
    // Check if game over
    lda ZP_LIVES
    bne hit_done
    lda #STATE_GAME_OVER
    sta ZP_GAME_STATE
    
hit_done:
    rts

// ============================================================================
// OXYGEN SYSTEM
// ============================================================================

update_oxygen:
    inc ZP_FRAME_COUNTER
    lda ZP_FRAME_COUNTER
    and #$1F                    // Every 32 frames
    bne oxygen_done
    
    // Check if near surface (regenerate oxygen)
    lda player_y
    cmp #50
    bcs oxygen_deplete
    
    // Regenerate oxygen
    lda ZP_PLAYER_OXYGEN
    cmp #OXYGEN_MAX
    bcs oxygen_done
    clc
    adc #5                      // Regenerate rate
    cmp #OXYGEN_MAX
    bcc store_oxygen
    lda #OXYGEN_MAX
    jmp store_oxygen
    
oxygen_deplete:
    // Deplete oxygen
    lda ZP_PLAYER_OXYGEN
    beq oxygen_damage           // Out of oxygen!
    sec
    sbc #1                      // Depletion rate
    
store_oxygen:
    sta ZP_PLAYER_OXYGEN
    
    // Check for warning threshold
    cmp #50
    bcs oxygen_done
    jsr sfx_oxygen_warning
    jmp oxygen_done
    
oxygen_damage:
    // Take damage from oxygen depletion
    jsr player_hit
    
oxygen_done:
    rts

// ============================================================================
// COLLISION DETECTION
// ============================================================================

check_collisions:
    // Read sprite-sprite collision register
    lda $D01E
    beq no_collision
    
    // Check if player (sprite 0) is involved
    and #$01
    beq check_bullet_hits
    
    // Player hit something
    jsr player_hit
    
check_bullet_hits:
    // Check if torpedoes hit enemies
    lda $D01E
    and #$02                    // Torpedo 1 (sprite 1)
    beq check_torpedo2_hit
    jsr torpedo1_hit_enemy
    
check_torpedo2_hit:
    lda $D01E
    and #$04                    // Torpedo 2 (sprite 2)
    beq no_collision
    jsr torpedo2_hit_enemy
    
no_collision:
    // Clear collision register
    lda $D01E
    rts

torpedo1_hit_enemy:
    // Deactivate torpedo
    lda #0
    sta torpedo1_active
    dec player_torpedoes
    
    // Play explosion sound
    jsr sfx_explosion
    
    // Add score (simplified - 100 points)
    jsr add_score_100
    rts

torpedo2_hit_enemy:
    // Deactivate torpedo
    lda #0
    sta torpedo2_active
    dec player_torpedoes
    
    // Play explosion sound
    jsr sfx_explosion
    
    // Add score
    jsr add_score_100
    rts

// ============================================================================
// SCORE MANAGEMENT
// ============================================================================

add_score_100:
    sed                         // Set decimal mode for BCD
    lda ZP_SCORE_LO
    clc
    adc #$00
    sta ZP_SCORE_LO
    lda ZP_SCORE_MID
    adc #$01                    // Add 100
    sta ZP_SCORE_MID
    lda ZP_SCORE_HI
    adc #$00
    sta ZP_SCORE_HI
    cld                         // Clear decimal mode
    rts
