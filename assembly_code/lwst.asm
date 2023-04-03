main:
      lui s0,0x10010
      addi s1,s1,1
      sw s1,0(s0)
      lw s2,0(s0)