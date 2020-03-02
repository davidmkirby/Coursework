---  C:\344L\Lab3\led_blink_mx7.c  ---------------------------------------------------------------
1:                   /******************************************************************************/
2:                   /*                                                                            */
3:                   /*      ECE 344L    -    Microprocessors    -    Spring 2020                  */
4:                   /*                                                                            */
5:                   /*      kirby_lab03.c  -  Digital I/O and Finite State Machine                */
6:                   /*                                                                            */
7:                   /******************************************************************************/
8:                   /*                                                                            */
9:                   /*      Author: David Kirby                                                   */
10:                  /*                                                                            */
11:                  /******************************************************************************/
12:                  /*                                                                            */
13:                  /*      File Description:                                                     */
14:                  /*          Implements a finite state machine using the LEDs and buttons on   */
15:                  /*          the chipKIT MX7 board.                                            */
16:                  /*                                                                            */
17:                  /******************************************************************************/
18:                  /*                                                                            */
19:                  /*      Revision History:                                                     */
20:                  /*          Original Source Code by: E.J. Nava, 9/23/18                       */
21:                  /*          Modified Code by: David Kirby, 01-Mar-2020                        */
22:                  /*                                                                            */
23:                  /******************************************************************************/
24:
25:                  #include <plib.h>
26:
27:                  /* -------------------------------------------------------------------------- */
28:                  /*                             Configuration Bits                             */
29:                  /* -------------------------------------------------------------------------- */
30:
31:                  // Configure MX7 board for debugging
32:                  #pragma config ICESEL = ICS_PGx1
33:
34:                  // SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
35:                  // Primary Osc w/PLL (XT+,HS+,EC+PLL)
36:
37:                  #pragma config FPLLMUL = MUL_20, FPLLIDIV = DIV_2
38:                  #pragma config FPLLODIV = DIV_1
39:                  #pragma config POSCMOD = EC, FNOSC = PRIPLL, FPBDIV = DIV_8
40:                  #pragma config FSOSCEN = OFF            // Secondary oscillator enable
41:                  #define SYS_FREQ (80000000L)
42:
43:                  // *** these are preconfigured on the MX4 Board for a clock frequency of 80MHz
44:                  // *** and a PBCLK value of 10MHz.
45:
46:                  /* -------------------------------------------------------------------------- */
47:                  /*                            Forward Declarations                            */
48:                  /* -------------------------------------------------------------------------- */
49:
50:                  void DeviceInit();
51:                  void DelayInit();
52:                  void DelayMs(int cms);
53:                  void DisplayInit(int coins);
54:
55:
56:                  /* -------------------------------------------------------------------------- */
57:                  /*                                  Definitions                               */
58:                  /* -------------------------------------------------------------------------- */
59:
60:                  #define cntMsDelay  10000           //timer 1 delay for 1ms
61:
62:                  /* -------------------------------------------------------------------------- */
63:                  /*                                     Main                                   */
64:                  /* -------------------------------------------------------------------------- */
65:
66:                  int main()
67:                  {
9D000008  27BDFFD8   addiu       sp,sp,-40
9D00000C  AFBF0024   sw          ra,36(sp)
9D000010  AFBE0020   sw          s8,32(sp)
9D000014  03A0F021   addu        s8,sp,zero
68:                          int button_in12 = 0;
9D000018  AFC00014   sw          zero,20(s8)
69:                          int button_in3 = 0;
9D00001C  AFC00018   sw          zero,24(s8)
70:                          int coins = 0;
9D000020  AFC00010   sw          zero,16(s8)
71:                          int msdelay = 100;
9D000024  24020064   addiu       v0,zero,100
9D000028  AFC2001C   sw          v0,28(s8)
72:
73:                          //Set LD1 through LD4 as digital output
74:                          DeviceInit();
9D00002C  0F4000E7   jal         0x9d00039c
9D000030  00000000   nop
75:                          //Initialize timer for delay
76:                          DelayInit();
9D000034  0F400105   jal         0x9d000414
9D000038  00000000   nop
77:
78:                          /* Perform the main application loop*/
79:                          while (1)
80:                          {
81:                                  // Read buttons
82:                                  button_in12 = PORTReadBits (IOPORT_G, BIT_6|BIT_7);
9D00003C  24040006   addiu       a0,zero,6
9D000040  240500C0   addiu       a1,zero,192
9D000044  0F4001A3   jal         0x9d00068c
9D000048  00000000   nop
9D00004C  AFC20014   sw          v0,20(s8)
83:                                  button_in3  = PORTReadBits (IOPORT_A, BIT_0);
9D000050  00002021   addu        a0,zero,zero
9D000054  24050001   addiu       a1,zero,1
9D000058  0F4001A3   jal         0x9d00068c
9D00005C  00000000   nop
9D000060  AFC20018   sw          v0,24(s8)
84:
85:                                  if (button_in12 != 0)
9D000064  8FC20014   lw          v0,20(s8)
9D000068  1040001C   beq         v0,zero,0x9d0000dc
9D00006C  00000000   nop
86:                                  {
87:                                          // drive both LD1 and LD2 high if both buttons pressed
88:                                          if (((button_in12 & 0x0040) != 0) &&
9D000070  8FC20014   lw          v0,20(s8)
9D000074  30420040   andi        v0,v0,0x40
9D000078  1040000A   beq         v0,zero,0x9d0000a4
9D00007C  00000000   nop
9D000088  10400006   beq         v0,zero,0x9d0000a4
9D00008C  00000000   nop
89:                                              ((button_in12 & 0x0080) != 0))
9D000080  8FC20014   lw          v0,20(s8)
9D000084  30420080   andi        v0,v0,0x80
90:                                                  coins = coins+15;
9D000090  8FC20010   lw          v0,16(s8)
9D000094  2442000F   addiu       v0,v0,15
9D000098  AFC20010   sw          v0,16(s8)
9D00009C  0B400037   j           0x9d0000dc
9D0000A0  00000000   nop
91:                                          else
92:                                          {
93:                                                  //drive LD1 high if only BTN1 pressed
94:                                                  if ((button_in12 & 0x0040) !=0) // BTN1 pressed?
9D0000A4  8FC20014   lw          v0,20(s8)
9D0000A8  30420040   andi        v0,v0,0x40
9D0000AC  10400004   beq         v0,zero,0x9d0000c0
9D0000B0  00000000   nop
95:                                                          coins = coins+5;
9D0000B4  8FC20010   lw          v0,16(s8)
9D0000B8  24420005   addiu       v0,v0,5
9D0000BC  AFC20010   sw          v0,16(s8)
96:                                                  //drive LD2 high if only BTN2 pressed
97:                                                  if ((button_in12 & 0x0080) != 0) // BTN2 pressed
9D0000C0  8FC20014   lw          v0,20(s8)
9D0000C4  30420080   andi        v0,v0,0x80
9D0000C8  10400004   beq         v0,zero,0x9d0000dc
9D0000CC  00000000   nop
98:                                                          coins = coins+10;
9D0000D0  8FC20010   lw          v0,16(s8)
9D0000D4  2442000A   addiu       v0,v0,10
9D0000D8  AFC20010   sw          v0,16(s8)
99:                                          }
100:                                 }
101:                                 // Handle BTN3 separately
102:                                 if(button_in3 !=0)
9D0000DC  8FC20018   lw          v0,24(s8)
9D0000E0  1040000D   beq         v0,zero,0x9d000118
9D0000E4  00000000   nop
103:                                 {
104:                                     coins=0;
9D0000E8  AFC00010   sw          zero,16(s8)
105:                 			              PORTWrite(IOPORT_G,BIT_12|BIT_13|BIT_14|BIT_15);
9D0000EC  24040006   addiu       a0,zero,6
9D0000F0  3405F000   ori         a1,zero,0xf000
9D0000F4  0F4001AD   jal         0x9d0006b4
9D0000F8  00000000   nop
106:                 			              DelayMs(msdelay); //flash lights if reset is hit
9D0000FC  8FC4001C   lw          a0,28(s8)
9D000100  0F40011E   jal         0x9d000478
9D000104  00000000   nop
107:                 			              PORTClearBits(IOPORT_G,BIT_12|BIT_13| BIT_14|BIT_15);
9D000108  24040006   addiu       a0,zero,6
9D00010C  3405F000   ori         a1,zero,0xf000
9D000110  0F4001B7   jal         0x9d0006dc
9D000114  00000000   nop
108:                 		            }
109:                                 //Initialize display
110:                                 DisplayInit(coins);
9D000118  8FC40010   lw          a0,16(s8)
9D00011C  0F40004B   jal         0x9d00012c
9D000120  00000000   nop
111:
112:                         }
9D000124  0B40000F   j           0x9d00003c
9D000128  00000000   nop
113:
114:                 }
115:
116:                 /* -------------------------------------------------------------------------- */
117:                 /*    DisplayInit()
118:                 **
119:                 **    Parameters:
120:                 **        coins             -amount of money entered
121:                 **        delay             -delay between blinks
122:                 **
123:                 **    Return Value:
124:                 **        none
125:                 **
126:                 **    Errors:
127:                 **        none
128:                 **
129:                 **    Description:
130:                 **        Set display state based on amount of money entered
131:                 /* -------------------------------------------------------------------------- */
132:
133:                 void DisplayInit(int coins)
134:                 {
9D00012C  27BDFFE0   addiu       sp,sp,-32
9D000130  AFBF001C   sw          ra,28(sp)
9D000134  AFBE0018   sw          s8,24(sp)
9D000138  03A0F021   addu        s8,sp,zero
9D00013C  AFC40020   sw          a0,32(s8)
135:                         int msdelay = 230;
9D000140  240200E6   addiu       v0,zero,230
9D000144  AFC20014   sw          v0,20(s8)
136:                         int timeout=0;
9D000148  AFC00010   sw          zero,16(s8)
137:
138:                         switch (coins)
9D00014C  8FC20020   lw          v0,32(s8)
9D000150  2442FFFB   addiu       v0,v0,-5
9D000154  2C43001F   sltiu       v1,v0,31
9D000158  10600086   beq         v1,zero,0x9d000374
9D00015C  00000000   nop
9D000160  00021880   sll         v1,v0,0x2
9D000164  3C029D00   lui         v0,0x9d00
9D000168  2442017C   addiu       v0,v0,380
9D00016C  00621021   addu        v0,v1,v0
9D000170  8C420000   lw          v0,0(v0)
9D000174  00400008   jr          v0
9D000178  00000000   nop
9D00017C  9D0001F8   lwu         zero,504(t0)
9D000180  9D000374   lwu         zero,884(t0)
9D000184  9D000374   lwu         zero,884(t0)
9D000188  9D000374   lwu         zero,884(t0)
9D00018C  9D000374   lwu         zero,884(t0)
9D000190  9D00021C   lwu         zero,540(t0)
9D000194  9D000374   lwu         zero,884(t0)
9D000198  9D000374   lwu         zero,884(t0)
9D00019C  9D000374   lwu         zero,884(t0)
9D0001A0  9D000374   lwu         zero,884(t0)
9D0001A4  9D000240   lwu         zero,576(t0)
9D0001A8  9D000374   lwu         zero,884(t0)
9D0001AC  9D000374   lwu         zero,884(t0)
9D0001B0  9D000374   lwu         zero,884(t0)
9D0001B4  9D000374   lwu         zero,884(t0)
9D0001B8  9D000264   lwu         zero,612(t0)
9D0001BC  9D000374   lwu         zero,884(t0)
9D0001C0  9D000374   lwu         zero,884(t0)
9D0001C4  9D000374   lwu         zero,884(t0)
9D0001C8  9D000374   lwu         zero,884(t0)
9D0001CC  9D000288   lwu         zero,648(t0)
9D0001D0  9D000374   lwu         zero,884(t0)
9D0001D4  9D000374   lwu         zero,884(t0)
9D0001D8  9D000374   lwu         zero,884(t0)
9D0001DC  9D000374   lwu         zero,884(t0)
9D0001E0  9D0002F0   lwu         zero,752(t0)
9D0001E4  9D000374   lwu         zero,884(t0)
9D0001E8  9D000374   lwu         zero,884(t0)
9D0001EC  9D000374   lwu         zero,884(t0)
9D0001F0  9D000374   lwu         zero,884(t0)
9D0001F4  9D000354   lwu         zero,852(t0)
139:                         {
140:                         case  5:
141:                                 //DelayMs(msdelay);
142:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
143:                                 DelayMs(msdelay);
9D0001F8  8FC40014   lw          a0,20(s8)
9D0001FC  0F40011E   jal         0x9d000478
9D000200  00000000   nop
144:                                 PORTWrite (IOPORT_G, BIT_12);   //001
9D000204  24040006   addiu       a0,zero,6
9D000208  24051000   addiu       a1,zero,4096
9D00020C  0F4001AD   jal         0x9d0006b4
9D000210  00000000   nop
145:                                 break;
9D000214  0B4000E1   j           0x9d000384
9D000218  00000000   nop
146:                         case 10:
147:                                 //DelayMs(msdelay);
148:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
149:                                 DelayMs(msdelay);
9D00021C  8FC40014   lw          a0,20(s8)
9D000220  0F40011E   jal         0x9d000478
9D000224  00000000   nop
150:                                 PORTWrite (IOPORT_G, BIT_13);   //010
9D000228  24040006   addiu       a0,zero,6
9D00022C  24052000   addiu       a1,zero,8192
9D000230  0F4001AD   jal         0x9d0006b4
9D000234  00000000   nop
151:                                 break;
9D000238  0B4000E1   j           0x9d000384
9D00023C  00000000   nop
152:                         case 15:
153:                                 //DelayMs(msdelay);
154:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
155:                                 DelayMs(msdelay);
9D000240  8FC40014   lw          a0,20(s8)
9D000244  0F40011E   jal         0x9d000478
9D000248  00000000   nop
156:                                 PORTWrite (IOPORT_G, BIT_12|BIT_13);   //011
9D00024C  24040006   addiu       a0,zero,6
9D000250  24053000   addiu       a1,zero,12288
9D000254  0F4001AD   jal         0x9d0006b4
9D000258  00000000   nop
157:                                 break;
9D00025C  0B4000E1   j           0x9d000384
9D000260  00000000   nop
158:                         case 20:
159:                                 //DelayMs(msdelay);
160:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
161:                                 DelayMs(msdelay);
9D000264  8FC40014   lw          a0,20(s8)
9D000268  0F40011E   jal         0x9d000478
9D00026C  00000000   nop
162:                                 PORTWrite (IOPORT_G, BIT_14);                              //100
9D000270  24040006   addiu       a0,zero,6
9D000274  24054000   addiu       a1,zero,16384
9D000278  0F4001AD   jal         0x9d0006b4
9D00027C  00000000   nop
163:                                 break;
9D000280  0B4000E1   j           0x9d000384
9D000284  00000000   nop
164:                         case 25:
165:                                 //DelayMs(msdelay);
166:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
167:                                 DelayMs(msdelay);
9D000288  8FC40014   lw          a0,20(s8)
9D00028C  0F40011E   jal         0x9d000478
9D000290  00000000   nop
168:                                 PORTWrite (IOPORT_G, BIT_12|BIT_14);                       //101
9D000294  24040006   addiu       a0,zero,6
9D000298  24055000   addiu       a1,zero,20480
9D00029C  0F4001AD   jal         0x9d0006b4
9D0002A0  00000000   nop
169:                                 break;
9D0002A4  0B4000E1   j           0x9d000384
9D0002A8  00000000   nop
170:                         case 30:
171:                                 //DelayMs(msdelay);
172:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
173:                                 while(timeout<3)
9D0002F0  8FC20010   lw          v0,16(s8)
9D0002F4  28420003   slti        v0,v0,3
9D0002F8  1440FFEC   bne         v0,zero,0x9d0002ac
9D0002FC  00000000   nop
174:                                 {
175:                                       DelayMs(msdelay);
9D0002AC  8FC40014   lw          a0,20(s8)
9D0002B0  0F40011E   jal         0x9d000478
9D0002B4  00000000   nop
176:                                       PORTWrite (IOPORT_G, BIT_15);                        //111
9D0002B8  24040006   addiu       a0,zero,6
9D0002BC  34058000   ori         a1,zero,0x8000
9D0002C0  0F4001AD   jal         0x9d0006b4
9D0002C4  00000000   nop
177:                                       DelayMs(msdelay);
9D0002C8  8FC40014   lw          a0,20(s8)
9D0002CC  0F40011E   jal         0x9d000478
9D0002D0  00000000   nop
178:                                       PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
9D0002D4  24040006   addiu       a0,zero,6
9D0002D8  3405F000   ori         a1,zero,0xf000
9D0002DC  0F4001B7   jal         0x9d0006dc
9D0002E0  00000000   nop
179:                                       timeout++;
9D0002E4  8FC20010   lw          v0,16(s8)
9D0002E8  24420001   addiu       v0,v0,1
9D0002EC  AFC20010   sw          v0,16(s8)
180:                                 }
181:                                 main();
9D000300  0F400002   jal         0x9d000008
9D000304  00000000   nop
182:                                 break;
9D000308  0B4000E1   j           0x9d000384
9D00030C  00000000   nop
183:                         case 35:
184:                                 //DelayMs(msdelay);
185:                                 //PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
186:                                 while(timeout<3)
9D000354  8FC20010   lw          v0,16(s8)
9D000358  28420003   slti        v0,v0,3
9D00035C  1440FFEC   bne         v0,zero,0x9d000310
9D000360  00000000   nop
187:                                 {
188:                                         DelayMs(msdelay);
9D000310  8FC40014   lw          a0,20(s8)
9D000314  0F40011E   jal         0x9d000478
9D000318  00000000   nop
189:                                         PORTWrite (IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);//111+
9D00031C  24040006   addiu       a0,zero,6
9D000320  3405F000   ori         a1,zero,0xf000
9D000324  0F4001AD   jal         0x9d0006b4
9D000328  00000000   nop
190:                                         DelayMs(msdelay);
9D00032C  8FC40014   lw          a0,20(s8)
9D000330  0F40011E   jal         0x9d000478
9D000334  00000000   nop
191:                                         PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
9D000338  24040006   addiu       a0,zero,6
9D00033C  3405F000   ori         a1,zero,0xf000
9D000340  0F4001B7   jal         0x9d0006dc
9D000344  00000000   nop
192:                                         timeout++;
9D000348  8FC20010   lw          v0,16(s8)
9D00034C  24420001   addiu       v0,v0,1
9D000350  AFC20010   sw          v0,16(s8)
193:                                 }
194:                                 main();
9D000364  0F400002   jal         0x9d000008
9D000368  00000000   nop
195:                                 break;
9D00036C  0B4000E1   j           0x9d000384
9D000370  00000000   nop
196:                         default:
197:                                 PORTClearBits(IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
9D000374  24040006   addiu       a0,zero,6
9D000378  3405F000   ori         a1,zero,0xf000
9D00037C  0F4001B7   jal         0x9d0006dc
9D000380  00000000   nop
198:                                 //Debug LEDs - send them all high at first, then trigger
199:                                 //PORTWrite (IOPORT_G, BIT_12|BIT_13|BIT_14|BIT_15);
200:                         }
201:                 }
9D000384  03C0E821   addu        sp,s8,zero
9D000388  8FBF001C   lw          ra,28(sp)
9D00038C  8FBE0018   lw          s8,24(sp)
9D000390  27BD0020   addiu       sp,sp,32
9D000394  03E00008   jr          ra
9D000398  00000000   nop
202:
203:                 /* -------------------------------------------------------------------------- */
204:                 /*    DeviceInit()
205:                 **
206:                 **    Parameters:
207:                 **        none
208:                 **
209:                 **    Return Value:
210:                 **        none
211:                 **
212:                 **    Errors:
213:                 **        none
214:                 **
215:                 **    Description:
216:                 **        Set LD1 through LD4 as digital output
217:                 /* -------------------------------------------------------------------------- */
218:
219:                 void DeviceInit()
220:                 {
9D00039C  27BDFFE8   addiu       sp,sp,-24
9D0003A0  AFBF0014   sw          ra,20(sp)
9D0003A4  AFBE0010   sw          s8,16(sp)
9D0003A8  03A0F021   addu        s8,sp,zero
221:                         // On MX7 board, disable JTAG function
222:                         DDPCONbits.JTAGEN = 0;
9D0003AC  3C03BF81   lui         v1,0xbf81
9D0003B0  8C62F200   lw          v0,-3584(v1)
9D0003B4  7C0218C4   ins         v0,zero,3,1
9D0003B8  AC62F200   sw          v0,-3584(v1)
223:
224:                         //On MX7 LED1 is on RG12
225:                         //       LED2 is on RG13
226:                         //       LED3 is on RG14
227:                         //       LED4 is on RG15
228:                         //Set ports for onboard LEDs to outputs & clear them
229:                         PORTSetPinsDigitalOut (IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
9D0003BC  24040006   addiu       a0,zero,6
9D0003C0  3405F000   ori         a1,zero,0xf000
9D0003C4  0F400193   jal         0x9d00064c
9D0003C8  00000000   nop
230:                         PORTClearBits(IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
9D0003CC  24040006   addiu       a0,zero,6
9D0003D0  3405F000   ori         a1,zero,0xf000
9D0003D4  0F4001B7   jal         0x9d0006dc
9D0003D8  00000000   nop
231:                         //Set ports for onboard BTNs as inputs
232:                         PORTSetPinsDigitalIn (IOPORT_G, BIT_6 | BIT_7);
9D0003DC  24040006   addiu       a0,zero,6
9D0003E0  240500C0   addiu       a1,zero,192
9D0003E4  0F400183   jal         0x9d00060c
9D0003E8  00000000   nop
233:                         PORTSetPinsDigitalIn (IOPORT_A, BIT_0);
9D0003EC  00002021   addu        a0,zero,zero
9D0003F0  24050001   addiu       a1,zero,1
9D0003F4  0F400183   jal         0x9d00060c
9D0003F8  00000000   nop
234:                 }
9D0003FC  03C0E821   addu        sp,s8,zero
9D000400  8FBF0014   lw          ra,20(sp)
9D000404  8FBE0010   lw          s8,16(sp)
9D000408  27BD0018   addiu       sp,sp,24
9D00040C  03E00008   jr          ra
9D000410  00000000   nop
235:
236:                 /* -------------------------------------------------------------------------- */
237:                 /*    DelayInit
238:                 **
239:                 **    Parameters:
240:                 **        none
241:                 **
242:                 **    Return Value:
243:                 **        none
244:                 **
245:                 **    Errors:
246:                 **        none
247:                 **
248:                 **    Description:
249:                 **        Initialized the hardware for use by delay functions. This
250:                 **        initializes Timer 1 to count at 10Mhz.
251:                 /* -------------------------------------------------------------------------- */
252:
253:                 void DelayInit()
254:                 {
9D000414  27BDFFF0   addiu       sp,sp,-16
9D000418  AFBE000C   sw          s8,12(sp)
9D00041C  03A0F021   addu        s8,sp,zero
255:                         unsigned int tcfg;
256:
257:                         /* Configure Timer 1 to count a 10MHz with a period of 0xFFFF*/
258:                         tcfg = T1_ON|T1_IDLE_CON|T1_SOURCE_INT|T1_PS_1_1|T1_GATE_OFF|T1_SYNC_EXT_OFF;
9D000420  34028000   ori         v0,zero,0x8000
9D000424  AFC20000   sw          v0,0(s8)
259:                         OpenTimer1(tcfg, 0xFFFF);
9D000428  8FC30000   lw          v1,0(s8)
9D00042C  3C02FFFF   lui         v0,0xffff
9D000430  34427FFF   ori         v0,v0,0x7fff
9D000434  00621824   and         v1,v1,v0
9D000438  3C02BF80   lui         v0,0xbf80
9D00043C  AC430600   sw          v1,1536(v0)
9D000440  3C02BF80   lui         v0,0xbf80
9D000444  AC400610   sw          zero,1552(v0)
9D000448  3C02BF80   lui         v0,0xbf80
9D00044C  3403FFFF   ori         v1,zero,0xffff
9D000450  AC430620   sw          v1,1568(v0)
9D000454  8FC20000   lw          v0,0(s8)
9D000458  30438000   andi        v1,v0,0x8000
9D00045C  3C02BF80   lui         v0,0xbf80
9D000460  AC430608   sw          v1,1544(v0)
260:                 }
9D000464  03C0E821   addu        sp,s8,zero
9D000468  8FBE000C   lw          s8,12(sp)
9D00046C  27BD0010   addiu       sp,sp,16
9D000470  03E00008   jr          ra
9D000474  00000000   nop
261:
262:                 /* -------------------------------------------------------------------------- */
263:                 /*    DelayMs
264:                 **
265:                 **    Parameters:
266:                 **        cms            - number of milliseconds to delay
267:                 **
268:                 **    Return Value:
269:                 **        none
270:                 **
271:                 **    Errors:
272:                 **        none
273:                 **
274:                 **    Description:
275:                 **        Delay the requested number of milliseconds. Uses Timer1.
276:                 /* -------------------------------------------------------------------------- */
277:
278:                 void DelayMs(int cms)
279:                 {
9D000478  27BDFFF0   addiu       sp,sp,-16
9D00047C  AFBE000C   sw          s8,12(sp)
9D000480  03A0F021   addu        s8,sp,zero
9D000484  AFC40010   sw          a0,16(s8)
280:                         int ims;
281:
282:                         for (ims=0; ims<cms; ims++)
9D000488  AFC00000   sw          zero,0(s8)
9D00048C  0B400130   j           0x9d0004c0
9D000490  00000000   nop
9D0004B4  8FC20000   lw          v0,0(s8)
9D0004B8  24420001   addiu       v0,v0,1
9D0004BC  AFC20000   sw          v0,0(s8)
9D0004C0  8FC30000   lw          v1,0(s8)
9D0004C4  8FC20010   lw          v0,16(s8)
9D0004C8  0062102A   slt         v0,v1,v0
9D0004CC  1440FFF1   bne         v0,zero,0x9d000494
9D0004D0  00000000   nop
283:                         {
284:                                 WriteTimer1(0);     // reset timer
9D000494  3C02BF80   lui         v0,0xbf80
9D000498  AC400610   sw          zero,1552(v0)
285:                                 while (ReadTimer1() < cntMsDelay); // wait for interval of 1 mS
9D00049C  00000000   nop
9D0004A0  3C02BF80   lui         v0,0xbf80
9D0004A4  8C420610   lw          v0,1552(v0)
9D0004A8  2C422710   sltiu       v0,v0,10000
9D0004AC  1440FFFC   bne         v0,zero,0x9d0004a0
9D0004B0  00000000   nop
286:                         }
287:
288:                 }
9D0004D4  03C0E821   addu        sp,s8,zero
9D0004D8  8FBE000C   lw          s8,12(sp)
9D0004DC  27BD0010   addiu       sp,sp,16
9D0004E0  03E00008   jr          ra
9D0004E4  00000000   nop
