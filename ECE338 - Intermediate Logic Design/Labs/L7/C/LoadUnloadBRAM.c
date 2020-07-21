// ========================================================================================================
// ========================================================================================================
// ********************************************* LoadUnload.c *********************************************
// ========================================================================================================
// ========================================================================================================

#include "common.h"

// ========================================================================================================
// ========================================================================================================
// Read integer data from a file and store it in an array.

int ReadData(int max_string_len, int max_data_vals, char *infile_name, short *data_arr_in)
{
   char line[max_string_len], *char_ptr;
   int temp_int;
   FILE *INFILE;
   int val_num;

   if ((INFILE = fopen(infile_name, "r")) == NULL)
   {
      printf("ERROR: ReadData(): Could not open %s\n", infile_name);
      fflush(stdout);
      exit(EXIT_FAILURE);
   }

   val_num = 0;
   while (fgets(line, max_string_len, INFILE) != NULL)
   {

      // Find the newline and eliminate it.
      if ((char_ptr = strrchr(line, '\n')) != NULL)
         *char_ptr = '\0';

      // Skip blank lines
      if (strlen(line) == 0)
         continue;

      // Sanity check
      if (val_num >= max_data_vals)
      {
         printf("ERROR: ReadData(): Exceeded maximum number of vals %d!\n", max_data_vals);
         fflush(stdout);
         exit(EXIT_FAILURE);
      }

      // Read and convert value into an integer
      if (sscanf(line, "%d", &temp_int) != 1)
      {
         printf("ERROR: ReadData(): Failed to read an integer from file '%s'!\n", line);
         fflush(stdout);
         exit(EXIT_FAILURE);
      }

      // Sanity check
      if (temp_int > MAX_SHORT_POS || temp_int < MAX_SHORT_NEG)
      {
         printf("ERROR: ReadData(): Integer larger than max or smaller than min value for short %d!\n", data_arr_in[val_num]);
         fflush(stdout);
         exit(EXIT_FAILURE);
      }

      data_arr_in[val_num] = (short)temp_int;

      val_num++;
   }

   fclose(INFILE);

   return val_num;
}

// ========================================================================================================
// ========================================================================================================
// Load the data from the data arry into the secure BRAM

void LoadUnloadBRAM(int max_string_len, int max_vals, int load_unload, int num_vals, short *IOData,
                    volatile unsigned int *CtrlRegA, volatile unsigned int *DataRegA, int ctrl_mask)
{
   int val_num, locked_up;

   // Set load control flag
   ctrl_mask = ctrl_mask | (load_unload << OUT_CP_LM_ULM_LOAD_UNLOAD);

   // Wait for the hardware to be ready
   while (((*DataRegA) & (1 << IN_SM_READY)) == 0)
      ;

   // Start the VHDL FSM memory controller
   *CtrlRegA = ctrl_mask | (1 << OUT_CP_START);
   *CtrlRegA = ctrl_mask;

   for (val_num = 0; val_num < num_vals; val_num++)
   {

      // Sanity check
      if (val_num >= max_vals)
      {
         printf("ERROR: LoadUnloadBRAM(): val_num %d greater than max_vals %d\n", val_num, max_vals);
         exit(EXIT_FAILURE);
      }

      // Four step protocol
      // 1) Wait for 'stopped' from hardware to be asserted
      //printf("LoadUnloadBRAM(): Waiting 'stopped'\n"); fflush(stdout);
      locked_up = 0;
      while (((*DataRegA) & (1 << IN_SM_HANDSHAKE)) == 0)
      {
         locked_up++;
         if (locked_up > 10000000)
         {
            printf("ERROR: LoadUnloadBRAM(): 'stopped' has not been asserted for the threshold number of cycles -- Locked UP?\n");
            fflush(stdout);
            locked_up = 0;
         }
      }

      // 2) Put data into GPIO (load) or get data from GPIO (unload). Assert 'continue' for hardware
      // Put the data bytes into the register and assert 'continue' (OUT_CP_HANDSHAKE).
      //printf("LoadUnloadBRAM(): Reading/writing data and asserting 'continue'\n"); fflush(stdout);
      if (load_unload == 0)
         *CtrlRegA = ctrl_mask | (1 << OUT_CP_HANDSHAKE) | (0x0000FFFF & IOData[val_num]);

      // When 'stopped' is asserted, the data is ready on the output register from the PNL BRAM -- get it.
      else
      {
         IOData[val_num] = (0x0000FFFF & *DataRegA);
         *CtrlRegA = ctrl_mask | (1 << OUT_CP_HANDSHAKE);
      }

      printf("%d\tData value written or read %d\n", val_num, IOData[val_num]);
      fflush(stdout);

      // 3) Wait for hardware to de-assert 'stopped'
      //printf("LoadUnloadBRAM(): Waiting de-assert of 'stopped'\n"); fflush(stdout);
      while (((*DataRegA) & (1 << IN_SM_HANDSHAKE)) != 0)
         ;

      // 4) De-assert 'continue'. ALSO, assert 'done' (OUT_CP_LM_ULM_DONE) SIMULTANEOUSLY if last word to inform hardware.
      //printf("LoadUnloadBRAM(): De-asserting 'continue' and possibly setting 'done'\n"); fflush(stdout);
      if (val_num == num_vals - 1)
         *CtrlRegA = ctrl_mask | (1 << OUT_CP_LM_ULM_DONE);
      else
         *CtrlRegA = ctrl_mask;
   }

   // Handle case where 'num_vals' is 0.
   if (num_vals == 0)
      *CtrlRegA = ctrl_mask | (1 << OUT_CP_LM_ULM_DONE);

   // De-assert 'OUT_CP_LM_ULM_DONE'
   *CtrlRegA = ctrl_mask;

   fflush(stdout);

   return;
}

// ========================================================================================================
// ========================================================================================================
// ========================================================================================================

int main(int argc, char *argv[])
{
   volatile unsigned int *CtrlRegA;
   volatile unsigned int *DataRegA;
   unsigned int ctrl_mask;

   char infile_name[MAX_STRING_LEN];

   // data arrays
   short *data_arr_in;
   short *data_arr_out;
   int num_vals;
   int load_unload;

//Timing variables.
#if DEBUG
   struct timeval t0, t1;
   long elapsed;
#endif

   // ======================================================================================================================
   // COMMAND LINE
   if (argc != 2)
   {
      printf("ERROR: LoadUnload.elf(): Datafile name (test_data_10vals.txt)\n");
      return (1);
   }

   sscanf(argv[1], "%s", infile_name);

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

   // Define array into which file data will be read
   if ((data_arr_in = (short *)calloc(sizeof(short), MAX_DATA_VALS)) == NULL)
   {
      printf("ERROR: Failed to calloc data 'in' array!\n");
      exit(EXIT_FAILURE);
   }
   if ((data_arr_out = (short *)calloc(sizeof(short), MAX_DATA_VALS)) == NULL)
   {
      printf("ERROR: Failed to calloc data 'out' array!\n");
      exit(EXIT_FAILURE);
   }

   // Read the data from the input file
   num_vals = ReadData(MAX_STRING_LEN, MAX_DATA_VALS, infile_name, data_arr_in);

   // Set the control mask to indicate enrollment.
   ctrl_mask = 0;

// Run time information
#ifdef DEBUG
   gettimeofday(&t0, 0);
#endif

   // Do a soft RESET
   *CtrlRegA = ctrl_mask | (1 << OUT_CP_RESET);
   *CtrlRegA = ctrl_mask;
   usleep(10000);

   // Load data into secure BRAM
   load_unload = 0;
   LoadUnloadBRAM(MAX_STRING_LEN, MAX_DATA_VALS, load_unload, num_vals, data_arr_in, CtrlRegA, DataRegA, ctrl_mask);

   // Read data back
   load_unload = 1;
   LoadUnloadBRAM(MAX_STRING_LEN, MAX_DATA_VALS, load_unload, num_vals, data_arr_out, CtrlRegA, DataRegA, ctrl_mask);

   return 0;
}
