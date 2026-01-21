; ===========================================================
; -- Super Metroid - Meteor Ball Revamped Version 1.0 --
; ===========================================================
; Author of original meteor ball hack is unknown
; Revamped version made by Kaepora Gaebora

lorom

; -- Game Variables --
!bombJumpDirection       = $0A56
!contactDmg       		 = $0A6E
!hasRunningMomentum      = $0B3C
!speedBoostCounter 		 = $0B3E

; -- Increase bomb jump velocities --
org $909EF7 : dw $0001    ; Initial Y speed in water during bomb jump
org $909EF9 : dw $0002    ; Initial Y speed in lava/acid during bomb jump
org $909F27 : dw $9000    ; X subacceleration during diagonal bomb jump
org $909F29 : dw $0005    ; Max X speed during diagonal bomb jump

org $90BF9B : dw $001C    ; Short bomb timer

org $90E04F : JSR $8EDF   ; Allow Samus to maintain meteor ball state

; -- Hijack --
org $90DF99 : JSR MeteorBall

; -- Meteor Ball Function --
org $90FD00
MeteorBall:
	LDA #$0001 : STA !contactDmg                ; Set Samus contact damage to speed boosting
    LDA #$0001 : STA !hasRunningMomentum        ; Set running momentum flag
    LDA #$0400 : STA !speedBoostCounter         ; Set speed booster counter to 4 (speed boosting)
	LDA #$001B : JSL $8090C1			        ; Play meteor ball SFX
    JSR $EEE7                                   ; Update speed echoes
    LDA !bombJumpDirection                      ; Load bomb jump direction to compensate for the hijack
    RTS
