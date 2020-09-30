// DUVIDAS:

// sleep nao funciona
// pq nao reconhece o sw?
// o que espera que a gente faca nas funcoes?
#include "motor.h"
#include <stdio.h>
#include <unistd.h>
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */
#include "sys/alt_irq.h"



int main()
{
  unsigned int *p_motor = (unsigned int *) PERIPHERAL_MOTOR_0_BASE;
  printf("uwu\n");

 char dir = 0;
  
  motor_en(p_motor);

  while(1) {  
  dir =! dir;
  motor_en(p_motor);
  motor_vel(p_motor + VEL_OFFSET, 1);
  usleep(7000000);
  motor_vel(p_motor + VEL_OFFSET, 3);
  usleep(7000000);
  motor_halt(p_motor);
  usleep(7000000);
  motor_dir(p_motor, dir);
  printf("-------\n");
  }

  return 0;
}
