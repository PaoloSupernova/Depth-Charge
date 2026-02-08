// ============================================================================
// DEPTH CHARGE - Commodore 64 Submarine Warfare Game
// Main Entry Point and Game Loop
// ============================================================================

.pc = $0801 "Basic Upstart"
BasicUpstart(start)

// ============================================================================
// CONSTANTS
// ============================================================================

// Game States
.const STATE_TITLE       = 0
.const STATE_PLAYING     = 1
.const STATE_PAUSED      = 2
.const STATE_LEVEL_DONE  = 3
.const STATE_GAME_OVER   = 4
.const STATE_HIGH_SCORES = 5

// VIC-II Registers
.const VIC_CTRL1         = $D011
.const VIC_CTRL2         = $D016
.const VIC_MEMORY        = $D018
.const VIC_BORDER        = $D020
.const VIC_BACKGROUND    = $D021
.const VIC_SPRITE_ENABLE = $D015
.const VIC_SPRITE_MC     = $D01C
.const VIC_SPRITE_COLL   = $D01E
.const VIC_SPRITE_BG_COLL = $D01F

// Screen Configuration
.const SCREEN_RAM        = $4000
.const CHARSET           = $2000
.const SPRITE_DATA       = $4800

// Game Constants
.const MAX_LIVES         = 3
.const MAX_TORPEDOES     = 2
.const OXYGEN_MAX        = 255
.const SCROLL_SPEED      = 1

// Joystick
.const JOY_PORT2         = $DC00
.const JOY_UP            = %00000001
.const JOY_DOWN          = %00000010
.const JOY_LEFT          = %00000100
.const JOY_RIGHT         = %00001000
.const JOY_FIRE          = %00010000

// ============================================================================
// ZERO PAGE VARIABLES
// ============================================================================

.label ZP_GAME_STATE       = $02
.label ZP_FRAME_COUNTER    = $03
.label ZP_SCROLL_X         = $04
.label ZP_PLAYER_X         = $05
.label ZP_PLAYER_Y         = $06
.label ZP_PLAYER_OXYGEN    = $07
.label ZP_LIVES            = $08
.label ZP_LEVEL            = $09
.label ZP_TEMP1            = $0A
.label ZP_TEMP2            = $0B

// Score (3 bytes, BCD)
.label ZP_SCORE_LO         = $0C
.label ZP_SCORE_MID        = $0D
.label ZP_SCORE_HI         = $0E

// ============================================================================
// MAIN PROGRAM
// ============================================================================

start:
    // Initialize system
    sei                         // Disable interrupts
    
    // Configure VIC-II
    lda #$18                    // Screen at $4000, charset at $2000
    sta VIC_MEMORY
    
    lda #$00                    // Black border
    sta VIC_BORDER
    
    lda #$06                    // Dark blue background (deep water)
    sta VIC_BACKGROUND
    
    // Enable all 8 sprites
    lda #$FF
    sta VIC_SPRITE_ENABLE
    
    // Set multicolor mode for sprites
    lda #$FF
    sta VIC_SPRITE_MC
    
    // Clear screen
    jsr clear_screen
    
    // Initialize game variables
    jsr init_game
    
    // Load graphics data
    jsr load_charset
    jsr load_sprites
    
    // Initialize sound
    jsr init_sound
    
    cli                         // Enable interrupts
    
    // Set initial game state to title screen
    lda #STATE_TITLE
    sta ZP_GAME_STATE

// ============================================================================
// MAIN GAME LOOP
// ============================================================================

main_loop:
    jsr wait_raster             // Sync to raster line 251
    
    // State machine
    lda ZP_GAME_STATE
    cmp #STATE_TITLE
    beq handle_title
    cmp #STATE_PLAYING
    beq handle_playing
    cmp #STATE_PAUSED
    beq handle_paused
    cmp #STATE_LEVEL_DONE
    beq handle_level_done
    cmp #STATE_GAME_OVER
    beq handle_game_over
    jmp main_loop

handle_title:
    jsr update_title_screen
    jsr check_start_game
    jmp main_loop

handle_playing:
    // --- UPDATE PHASE ---
    jsr read_joystick           // Read player input
    jsr update_player           // Move player, handle firing
    jsr update_enemies          // AI movement patterns
    jsr update_bullets          // Move all projectiles
    jsr update_scroll           // Advance scroll position
    jsr spawn_enemies           // Check spawn table, create enemies
    jsr check_collisions        // Sprite-sprite and sprite-background
    jsr update_oxygen           // Deplete/refill oxygen meter
    jsr update_animations       // Sprite frame cycling
    
    // --- RENDER PHASE ---
    jsr update_sprites          // Set VIC-II sprite positions
    jsr draw_hud                // Update score, lives, oxygen bar
    
    // --- AUDIO PHASE ---
    jsr play_music              // Advance music player
    jsr play_sfx                // Process sound effect queue
    
    // Check for pause
    jsr check_pause
    
    // Check for level complete or game over
    jsr check_level_status
    
    jmp main_loop

handle_paused:
    jsr update_pause_screen
    jsr check_unpause
    jmp main_loop

handle_level_done:
    jsr update_level_done_screen
    jsr check_next_level
    jmp main_loop

handle_game_over:
    jsr update_game_over_screen
    jsr check_restart
    jmp main_loop

// ============================================================================
// INITIALIZATION ROUTINES
// ============================================================================

init_game:
    lda #MAX_LIVES
    sta ZP_LIVES
    
    lda #OXYGEN_MAX
    sta ZP_PLAYER_OXYGEN
    
    lda #1
    sta ZP_LEVEL
    
    // Clear score
    lda #0
    sta ZP_SCORE_LO
    sta ZP_SCORE_MID
    sta ZP_SCORE_HI
    
    // Initialize player position
    lda #40
    sta ZP_PLAYER_X
    lda #100
    sta ZP_PLAYER_Y
    
    lda #0
    sta ZP_SCROLL_X
    sta ZP_FRAME_COUNTER
    
    rts

clear_screen:
    ldx #0
    lda #$20                    // Space character
clear_loop:
    sta SCREEN_RAM,x
    sta SCREEN_RAM+$100,x
    sta SCREEN_RAM+$200,x
    sta SCREEN_RAM+$300,x
    inx
    bne clear_loop
    rts

wait_raster:
    lda #251
wait_raster_loop:
    cmp $D012
    bne wait_raster_loop
    rts

// ============================================================================
// INCLUDE OTHER MODULES
// ============================================================================

#import "player.asm"
#import "enemies.asm"
#import "scroll.asm"
#import "sprites.asm"
#import "sound.asm"
#import "graphics.asm"
#import "data.asm"
