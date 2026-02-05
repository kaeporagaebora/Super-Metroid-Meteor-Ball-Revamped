; ===========================================================
; -- Super Metroid - Meteor Ball Revamped Version 1.1 --
; ===========================================================
; Author of original meteor ball hack is unknown
; Revamped version made by Kaepora Gaebora

lorom

; -- Game Variables --
!bombJumpDirection       = $0A56
!contactDmg       		 = $0A6E
!hasRunningMomentum      = $0B3C
!speedBoostCounter 		 = $0B3E
!inMeteorState           = $1F70

; -- Increase bomb jump velocities --
org $909EF7 : dw $0001    ; Initial Y speed in water during bomb jump
org $909EF9 : dw $0002    ; Initial Y speed in lava/acid during bomb jump
org $909F27 : dw $9000    ; X subacceleration during diagonal bomb jump
org $909F29 : dw $0005    ; Max X speed during diagonal bomb jump
org $90BF9B : dw $001C    ; Short bomb timer

org $90E04F : JSR $8EDF   ; Allow Samus to maintain meteor ball state

; -- Hijack --
org $90DF99 : JSR MeteorBall
org $84B408 : JSL QuicksandFix : NOP #2         ; Hijack quicksand collision function
org $91E931 : JSL ClearMeteorState : NOP #2     ; Clear meteor ball state flag when landing

; -- Meteor Ball Function --
org $90FD00
MeteorBall:
	LDA #$0001 : STA !inMeteorState             ; Set in meteor ball state flag
	LDA #$0001 : STA !contactDmg                ; Set Samus contact damage to speed boosting
    LDA #$0001 : STA !hasRunningMomentum        ; Set running momentum flag
    LDA #$0400 : STA !speedBoostCounter         ; Set speed booster counter to 4 (speed boosting)
	LDA #$001B : JSL $8090C1			        ; Play meteor ball SFX
    JSR $EEE7                                   ; Update speed echoes
    LDA !bombJumpDirection                      ; Hijack compensation
    RTS

; Prevents Samus from getting stuck in quicksand while in meteor ball state
QuicksandFix:
	STZ !hasRunningMomentum : STZ !speedBoostCounter   ; Hijack compensation
	LDA !inMeteorState : BEQ QuicksandNotMeteor        ; If not in meteor ball state, exit
	JSR $8F1B : STZ !inMeteorState					   ; Jump to handle end of bomb jump then clear meteor ball state
	RTL

QuicksandNotMeteor:
	RTL

ClearMeteorState:
    STZ !inMeteorState                ; Clear in meteor ball state flag
    LDA $0DC7 : AND #$00FF			  ; Hijack compensation
    RTL