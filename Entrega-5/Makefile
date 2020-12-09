TARGET = file
PYTHON = main.py
IP = 192.168.1.104
SCP = sshpass -p '1234' scp $(TARGET) root@$(IP)\:/home/root
SCP_PYTHON = sshpass -p '1234' scp $(PYTHON) root@$(IP)\:/home/root
SSH = ssh -tt root@$(IP) ./$(TARGET)
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)gcc
ARCH= arm

build: $(TARGET)

$(TARGET): main.o 
	$(CC) $(LDFLAGS)   $^ -o $@ 

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~

.PHONY: deploy
deploy:
	${SCP}
	${SCP_PYTHON}

.PHONY: run 
run:
	 ${SSH}