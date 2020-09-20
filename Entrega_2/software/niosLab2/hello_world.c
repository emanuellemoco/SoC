#include <stdio.h>
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */

int delay(int n){
      unsigned int delay = 0 ;
      while(delay < n){
          delay++;
      }
}
// PIO 0 led
// PIO 1 sw
// PIO 2 motor

int main(void){
  unsigned int phases = 0;

  printf("Embarcados++++ \n");
  int sw, sleep;
  char on, dir ;

  while(1){
	  	 on = 0;
	  	 dir = 0;
	  	 sleep = 50000;

	     sw = IORD_32DIRECT(PIO_1_BASE, 0) & 0x07;
	     if (sw & 1) on = 1; //ON OFF

	     if (sw & 2)  dir = 1;  //DIR ??? como fazer????

	     if (sw & 4) sleep /= 2; //VEL

	     if (sw & 8) sleep /= 2; //VEL ???????? n ta funcionando


	  if (on){
		  if (phases <= 5){
			  IOWR_32DIRECT(PIO_2_BASE, 0, 0x01 << phases++);

			  usleep(sleep);
		  }
		  else{
			  phases = 0;
		  }
	  }


  };

  return 0;
}
