main:
      add zero,zero,zero
      addi s0,s0,2
      addi s1,s1,2
      blt s0,s1,condition
      addi s0,s0,-1
      blt s0,s1,condition
      addi s4,s4,4
condition:
      addi s3,s3,3