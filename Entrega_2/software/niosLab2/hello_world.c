#include <stdio.h>
#include <unistd.h>
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */
#include "sys/alt_irq.h"

volatile int edge_capture, sw, vel;
volatile char on, dir ;

int delay(int n){
      unsigned int delay = 0 ;
      while(delay < n){
          delay++;
      }
}

void handle_button_interrupts(void* context, alt_u32 id)
{
	printf("entrei interrupt\n");
    volatile int* edge_capture_ptr = (volatile int*) context;
    printf("-> %d\n",*edge_capture_ptr);
    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE);
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0);

    sw = IORD_ALTERA_AVALON_PIO_DATA(PIO_1_BASE);
    if (*edge_capture_ptr & 1) on = !on;  //ON OFF

    if (*edge_capture_ptr & 2)  dir = !dir;  //DIR

    vel = (sw >> 2);
}

void init_pio()
{
	printf("entrei init_pio\n");
    void* edge_capture_ptr = (void*) &edge_capture;
    /* Enable first four interrupts. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_1_BASE, 0xf);
    /* Reset the edge capture register. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_1_BASE, 0x0);
    /* Register the interrupt handler. */
    alt_irq_register( PIO_1_IRQ, edge_capture_ptr,
                      handle_button_interrupts );
}


int main(void){
  unsigned int phases = 0;
  int sleep = 100000;
  on = 0;
  dir = 0;
  printf("Embarcados++++++ \n");


  init_pio();
  while(1){



	  if (on){
		  if (phases <= 5){
			  if (dir) IOWR_32DIRECT(PIO_2_BASE, 0, 0x08 >> phases++);
			  	  else  IOWR_32DIRECT(PIO_2_BASE, 0, 0x01 << phases++);
				  usleep(sleep / (vel + 1));
		  }
		  else{
			  phases = 0;
		  }
	  }



  };

  return 0;
}
