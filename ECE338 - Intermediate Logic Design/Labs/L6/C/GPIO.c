// ========================================================================================================
// ========================================================================================================
// ************************************************* GPIO.c ***********************************************
// ========================================================================================================
// ========================================================================================================

#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <time.h>
#include <sys/time.h>

// =================================
// GPIO constants
#define GPIO_0_BASE_ADDR 0x41200000
#define CTRL_DIRECTION_MASK 0x00
#define DATA_DIRECTION_MASK 0xFFFFFFFF

#define OUT_CP_RESET 31

// ========================================================================================================
// ========================================================================================================
// ========================================================================================================

int main(int argc, char *argv[])
{
   volatile unsigned int *CtrlRegA;
   volatile unsigned int *DataRegA;
   unsigned int ctrl_mask;

   // ======================================================================================================================
   // COMMAND LINE
   if (argc != 1)
   {
      printf("ERROR: GPIO.elf(): No Params)\n");
      return (1);
   }

   // Open up the memory mapped device so we can access the GPIO registers.
   int fd = open("/dev/mem", O_RDWR | O_SYNC);

   if (fd < 0)
   {
      printf("ERROR: /dev/mem could NOT be opened!\n");
      exit(EXIT_FAILURE);
   }

   // Add 2 for the DataReg (for an offset of 8 bytes for 32-bit integer variables)
   DataRegA = mmap(0, getpagesize(), PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_0_BASE_ADDR);
   CtrlRegA = DataRegA + 2;

   // Set the control mask to indicate enrollment.
   ctrl_mask = 0;

   // Do a soft RESET
   *CtrlRegA = ctrl_mask | (1 << OUT_CP_RESET);
   *CtrlRegA = ctrl_mask;
   usleep(10000);

   return 0;
}
