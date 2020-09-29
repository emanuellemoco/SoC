// DUVIDAS:

// sleep nao funciona
// pq nao reconhece o sw?
// o que espera que a gente faca nas funcoes?
#include <stdio.h>
#include <unistd.h>
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */
#include "sys/alt_irq.h"

#define VEL_OFFSET 1

int motor_init(unsigned int *p_motor){ // Inicializa o periférico
  *(p_motor) = 0x1 | *(p_motor);
}

int motor_halt(unsigned int *p_motor){ // Desativa o periférico
  printf("Motor Halt: %d\n", *(p_motor)); 
  *(p_motor) = 0x00 | *(p_motor); 
  printf("Motor Halt: %d\n", *(p_motor)); 
}

int motor_en(unsigned int *p_motor){ // retorna se houve algum click
  *(p_motor) = 0x1 | *(p_motor);
  printf("Motor EN\n");
}

int motor_dir(unsigned int *p_motor, int dir){ //
  *(p_motor) = (dir << 1) | *(p_motor);
  printf("Motor Dir: %d\n", dir ); 
}

int motor_vel(unsigned int *p_motor, int vel){
  *(p_motor) = (vel);
  printf("Motor Vel: %d\n", *(p_motor));   
}

int main()
{
  unsigned int *p_motor = (unsigned int *) PERIPHERAL_MOTOR_0_BASE;
  printf("UwU!!Iii!!!! \n");

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
  motor_dir(p_motor, dir);
  printf("-------\n");
  }

  return 0;
}
