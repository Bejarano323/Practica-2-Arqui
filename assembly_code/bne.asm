main:
      addi s0,s0,1
      addi s1,s1,1
      bne s0,s1,condition
      addi s0,s0,1
      bne s0,s1,condition
      addi s4,s4,4
condition:
      addi s3,s3,3