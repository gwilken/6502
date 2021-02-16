PORTB = $6000
PORTA = $6001
DDRB  = $6002    ; data direction register  
DDRA  = $6003

E  = %10000000
RW = %01000000
RS = %00100000

  .org $8000

reset:
  ldx #$ff        ; load ff into x register
  txs             ; transfer x -> stack pointer to init it to ff

  lda #%11111111  ; set all pins pn port B to output  
  sta DDRB

  lda #%11100000  ; set top 3 bits on port A to output
  sta DDRA

  lda #%00111000  ; set 8 bit mode, 2 line display, 5x8 font
  jsr lcd_instruction

  lda #%00001110  ; display on; cursor, blink on
  jsr lcd_instruction

  lda #%00000110  ; increment and shift cursor
  jsr lcd_instruction

  lda #$00000001  ; clear display
  jsr lcd_instruction


  ldx #0


print_message:
  lda message,x
  beq loop
  jsr print_char
  inx
  jmp print_message

 
loop:
  jmp loop


lcd_instruction:
  jsr lcd_wait
  sta PORTB

  lda #0          ; clear RS/RW/E bits
  sta PORTA

  lda #E          ; set enable bit
  sta PORTA

  lda #0
  sta PORTA
  rts             ; return from sub routine
  

print_char:
  jsr lcd_wait
  sta PORTB

  lda #RS          ; set RS bit
  sta PORTA

  lda #(RS | E)    ; set RS and Enable bit
  sta PORTA

  lda #RS
  sta PORTA
  rts


message: .asciiz "     Chad!                              Bring cold beer!"    ; internally lcd display is 40chars long, char 41 will appear on next line


lcd_wait:
  pha
  lda #%00000000  ; set Port B as input 
  sta DDRB        ; the symbol for data direction memory address for portb
lcd_busy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB       ; read result from Port B
  and #%10000000  ; use bitwise and to pick out busy flag of lcd and set zero flag of cpu
  bne lcd_busy

  lda #RW         ; clean up, turn off enable bit
  sta PORTA
  lda #%11111111  ; set Port B as input 
  sta DDRB
  pla
  rts


  .org $fffc
  .word reset
  .word $0000   ;padding