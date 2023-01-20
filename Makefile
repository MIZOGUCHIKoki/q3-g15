AS = arm-none-eabi-as 
LD = arm-none-eabi-ld
OBJ = arm-none-eabi-objcopy
LDFRAGS = -m armelf
OBJFLAGS = -O binary



%.img: %.elf
	$(OBJ) $< $(OBJFLAGS) $@
	rm *.o *.elf 
ra.elf: program.o
	$(LD) $(LDFRAGS) $+ -o $@

%.elf: %.o 
	$(LD) $(LDFRAGS) $< -o $@

%.o: %.s 
	$(AS) $< -o $@

%: %.s

.PHONY: clean
clean:
	rm -f  *.img
