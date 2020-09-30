#define VEL_OFFSET 1

int motor_init(unsigned int *p_motor){ // Inicializa o periférico
  *(p_motor) = 0x1 | *(p_motor);
}

int motor_halt(unsigned int *p_motor){ // Desativa o periférico
  printf("Motor Halt: %d\n", *(p_motor)); 
  *(p_motor) = 0x00; 
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
