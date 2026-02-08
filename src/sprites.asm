// ============================================================================
// SPRITES MODULE
// Sprite data and animation system
// ============================================================================

// ============================================================================
// LOAD SPRITES INTO MEMORY
// ============================================================================

load_sprites:
    // Copy sprite data to sprite memory area
    ldx #0
copy_sprite_loop:
    lda sprite_data,x
    sta SPRITE_DATA,x
    lda sprite_data+$100,x
    sta SPRITE_DATA+$100,x
    lda sprite_data+$200,x
    sta SPRITE_DATA+$200,x
    lda sprite_data+$300,x
    sta SPRITE_DATA+$300,x
    lda sprite_data+$400,x
    sta SPRITE_DATA+$400,x
    inx
    bne copy_sprite_loop
    
    // Set sprite colors
    jsr init_sprite_colors
    
    rts

init_sprite_colors:
    // Sprite 0 (Player) - Grey/White
    lda #$0C                    // Grey
    sta $D027                   // Sprite 0 color
    
    // Sprite 1-2 (Torpedoes) - Yellow
    lda #$07                    // Yellow
    sta $D028
    sta $D029
    
    // Sprites 3-7 (Enemies) - Various colors
    lda #$05                    // Green (surface ships)
    sta $D02A
    
    lda #$02                    // Red (enemy subs)
    sta $D02B
    
    lda #$0B                    // Dark grey (mines)
    sta $D02C
    
    lda #$0F                    // Light grey (aircraft)
    sta $D02D
    
    lda #$02                    // Red (projectiles)
    sta $D02E
    
    // Multicolor sprite shared colors
    lda #$07                    // Yellow (lights/details)
    sta $D025
    
    lda #$0B                    // Dark grey (shadows)
    sta $D026
    
    rts

// ============================================================================
// UPDATE SPRITES - Position and animation
// ============================================================================

update_sprites:
    // This is called from main loop
    // Individual sprite positions are updated in their respective modules
    // This handles sprite enable/disable based on active flags
    
    lda #$01                    // Player always enabled
    sta ZP_TEMP1
    
    // Enable torpedo sprites if active
    lda torpedo1_active
    beq check_torp2
    lda ZP_TEMP1
    ora #$02                    // Enable sprite 1
    sta ZP_TEMP1
    
check_torp2:
    lda torpedo2_active
    beq check_enemies
    lda ZP_TEMP1
    ora #$04                    // Enable sprite 2
    sta ZP_TEMP1
    
check_enemies:
    // Enable enemy sprites (3-7) based on active flags
    ldx #0
enemy_sprite_loop:
    lda enemy_active,x
    beq skip_enemy_sprite
    
    txa
    clc
    adc #3                      // Sprite numbers 3-7
    tay
    lda #$01
    
shift_enable:
    dey
    beq store_enable
    asl
    jmp shift_enable
    
store_enable:
    ora ZP_TEMP1
    sta ZP_TEMP1
    
skip_enemy_sprite:
    inx
    cpx #MAX_ENEMIES
    bcc enemy_sprite_loop
    
    // Write sprite enable register
    lda ZP_TEMP1
    sta VIC_SPRITE_ENABLE
    
    rts

// ============================================================================
// ANIMATION SYSTEM
// ============================================================================

update_animations:
    // Update player animation (already handled in player.asm)
    
    // Update enemy animations
    ldx #0
anim_enemy_loop:
    lda enemy_active,x
    beq next_anim_enemy
    
    // Simple frame cycling based on frame counter
    lda ZP_FRAME_COUNTER
    and #$08
    lsr
    lsr
    lsr
    clc
    adc enemy_type,x
    adc #(SPRITE_DATA/$40)+5
    
    // Store sprite pointer
    txa
    clc
    adc #$FB                    // Sprite pointer offset
    tay
    sta SCREEN_RAM,y
    
next_anim_enemy:
    inx
    cpx #MAX_ENEMIES
    bcc anim_enemy_loop
    
    rts

// ============================================================================
// SPRITE DATA
// Each sprite is 64 bytes (24x21 pixels)
// ============================================================================

sprite_data:

// Sprite 0: Player Submarine (Frame 1)
.byte $00,$7E,$00  // Row 1
.byte $01,$FF,$80  // Row 2
.byte $03,$FF,$C0  // Row 3
.byte $07,$FF,$E0  // Row 4
.byte $0F,$FF,$F0  // Row 5
.byte $1F,$FF,$F8  // Row 6
.byte $1F,$FF,$F8  // Row 7
.byte $3F,$FF,$FC  // Row 8
.byte $3F,$FF,$FC  // Row 9
.byte $7F,$FF,$FE  // Row 10
.byte $7F,$FF,$FE  // Row 11 (widest point - conning tower)
.byte $7F,$FF,$FE  // Row 12
.byte $3F,$FF,$FC  // Row 13
.byte $3F,$FF,$FC  // Row 14
.byte $1F,$FF,$F8  // Row 15
.byte $1F,$FF,$F8  // Row 16
.byte $0F,$FF,$F0  // Row 17
.byte $07,$FF,$E0  // Row 18
.byte $03,$FF,$C0  // Row 19
.byte $01,$FF,$80  // Row 20
.byte $00,$7E,$00  // Row 21
.byte $00,$00,$00  // Padding

// Sprite 1: Player Submarine (Frame 2 - propeller variant)
.byte $00,$7E,$00
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $0F,$FF,$F0
.byte $07,$FF,$E0
.byte $03,$FF,$C0
.byte $01,$FF,$80
.byte $00,$FF,$00
.byte $00,$00,$00

// Sprite 2: Player Submarine (Frame 3 - damage state)
.byte $00,$7E,$00
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $0F,$FF,$F0
.byte $07,$FF,$E0
.byte $03,$FF,$C0
.byte $01,$FF,$80
.byte $00,$7E,$00
.byte $00,$00,$00

// Sprite 3: Torpedo
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $01,$FF,$FC
.byte $03,$FF,$FE
.byte $07,$FF,$FF
.byte $0F,$FF,$FF
.byte $07,$FF,$FF
.byte $03,$FF,$FE
.byte $01,$FF,$FC
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00
.byte $00,$00,$00

// Sprite 4: Empty placeholder
.fill 64, $00

// Sprite 5: Surface Ship
.byte $00,$7E,$00
.byte $00,$FF,$00
.byte $01,$FF,$80
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $FF,$FF,$FF
.byte $FF,$FF,$FF
.byte $FF,$FF,$FF
.byte $FF,$FF,$FF
.byte $00,$00,$00
.byte $00,$00,$00

// Sprite 6: Enemy Submarine
.byte $00,$7E,$00
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $7F,$FF,$FE
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $1F,$FF,$F8
.byte $1F,$FF,$F8
.byte $0F,$FF,$F0
.byte $07,$FF,$E0
.byte $03,$FF,$C0
.byte $01,$FF,$80
.byte $00,$7E,$00
.byte $00,$00,$00

// Sprite 7: Mine
.byte $00,$3C,$00
.byte $00,$7E,$00
.byte $00,$FF,$00
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $7F,$FF,$FE
.byte $FF,$FF,$FF
.byte $7F,$FF,$FE
.byte $3F,$FF,$FC
.byte $1F,$FF,$F8
.byte $0F,$FF,$F0
.byte $07,$FF,$E0
.byte $03,$FF,$C0
.byte $01,$FF,$80
.byte $00,$FF,$00
.byte $00,$7E,$00
.byte $00,$3C,$00
.byte $00,$00,$00

// Sprite 8: Aircraft
.byte $00,$18,$00
.byte $00,$3C,$00
.byte $00,$7E,$00
.byte $00,$FF,$00
.byte $01,$FF,$80
.byte $03,$FF,$C0
.byte $07,$FF,$E0
.byte $0F,$FF,$F0
.byte $1F,$FF,$F8
.byte $3F,$FF,$FC
.byte $3F,$FF,$FC
.byte $1F,$FF,$F8
.byte $0F,$FF,$F0
.byte $07,$FF,$E0
.byte $03,$FF,$C0
.byte $01,$FF,$80
.byte $00,$FF,$00
.byte $00,$7E,$00
.byte $00,$3C,$00
.byte $00,$18,$00
.byte $00,$00,$00
.byte $00,$00,$00

// Fill remaining sprite slots
.fill (21*64 - (* - sprite_data)), $00
