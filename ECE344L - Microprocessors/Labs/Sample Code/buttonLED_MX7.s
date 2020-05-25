# Originally Written by: L. Howard Pollard
# Modified to use LAT and ported to MX-7 Development board by: E.J. Nava, 9/23/19
#
# Program to turn on LEDs according to the pattern of buttons.
#
# On the MX-7 trainer board are located 4 LEDs and 2 buttons.
# In particular, 
# the 4 LEDs are activated by Port G bit positions 12 to 15.
# That means that TRISB (15:12) needs to be set to zero to 
# configure the bits as outputs, and also ODCB (15:12) need
# to be set to 0 for standard output configuration.  Then 
# the appropriate value can be written to the LEDs by sending
# bit pattern to Port G LAT register (15:12) as needed.
#
# The Buttons are a little bit more complicated.  The schematic
# page is also page 4, using Port G, positions 6 and 7.  Looking
# at the schematic it is evident that if the button is open, then
# the bit is at a low voltage.  If the button is closed, then
# the bit is at a high voltage.  To configure the port to make
# the bits function in this way, TRISG(7:6) needs to be set as
# inputs (TRISA(7:6) set to 1's) while ODCA is not used.  In
# this implementation, ODCA(7:6) are set to 1's anyway.  Then
# the information is passed to the program by reading PORTG(7:6).
#
.global main 

.text

.set noreorder

.ent main

  .set PROGIO,   0xBF88       # base for programmed I/O
  .set MSBSIO,   0xC000       # two MSBs for progio
  .set LSBSIO,   0x3000       # two LSBs for progio
  .set TRISG,    0x6180       # address of TRISG reg
  .set TRISGCLR, 0x6184       # address to clear TRISG bits
  .set TRISGSET, 0x6188       # address to set TRISG bits
  .set PORTG,    0x6190       # address of PORTG read reg
  .set PORTGCLR, 0x6194       # address of PORTB read reg - clear bits
  .set PORTGSET, 0x6198       # address of PORTB read reg - set bits
  .set LATG,     0x61A0       # address of PORTG write reg
  .set LATGCLR,  0x61A4       # address of PORTB write reg - clear bits
  .set LATGSET,  0x61A8       # address of PORTB write reg - set bits
  .set ODCG,     0x61B0       # address of ODCG reg
  .set ODCGCLR,  0x61B4       # address to clear ODCG bits
  .set ODCGSET,  0x61B8       # address to set ODCG bits


main:
   nop                        # point PC here
   nop                        # to get things started
   nop
   li $t1,MSBSIO              # let T1 have most sig pattern
   li $t2,LSBSIO              # let T2 have least sig pattern
init:
   nop                        # start with port B
   lui $s7,PROGIO             # set up S7 as base reg (point to SFRs)
   nop                        # separator code only...
                              # set up bits 12-15 as outputs for LEDs
   li $t3,0xF000              # set T3 to 1111 0000 0000 0000
   sw $t3,TRISGCLR($s7)       # write to TRISGCLR address to clear bits
   sw $t3,ODCGCLR($s7)        # and also ODCGCLR address to clear bits
   nop                        # separator code only...
   
   nop                        # configure bits 6 & 7 button inputs
   li $s6,0xC0                # put 1100 0000 in S6
   sw $s6,TRISGSET($s7)       # TRISA bits (7:6) to 1
   sw $s6,ODCGSET($s7)        # ODCA to 1's in those two bits
   nop
   nop                        # initialization complete; goto steady state
floop:
   lw $s4,PORTG($s7)           # read PORTG, bits to S4
   andi $s0,$s4,0x40          # test bit 6 (0x40) 
   bne $0,$s0,lbl1            # if = 1, goto lbl1
   nop                        # compulsory NOP
   sw $t2,LATGCLR($s7)        # gotta be 0, so clr bits in PORTB
   b lbl2                     # then goto lbl2
   nop                        # compulsory NOP
lbl1:
   sw $t2,LATGSET($s7)        # else? set bits PORTB
   nop                        # compulsory NOP
lbl2:                         # now check other button
   andi $s0,$s4,0x80          # test bit 7 (0x80)
   bne $0,$s0,lbl3            # if = 1, goto lb13
   nop                        # compulsory NOP
   sw $t1,LATGCLR($s7)       # again, gotta be 0, so clear bits in PORTB
   b lbl4                     # then goto lbl4
   nop                        # compulsory NOP
lbl3:
   sw $t1,LATGSET($s7)       # else? set bits in PORTB
   nop                        # compulsory NOP
lbl4:
   b floop                    # do it all again
   nop                        # compulsory NOP
   nop

.end main
