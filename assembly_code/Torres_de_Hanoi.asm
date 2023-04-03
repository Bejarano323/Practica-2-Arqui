#Isaac Castillo Herrera is726476
#Diego Lopez Valencia ie720082


#numero de movimientos = 2^n -1
#t1,t2,t3 son las torres (torre 1, torre 2 y torre 3 por convencionalidad)
#s0 será el núemro de discos

.eqv n s0


.text

MAIN:

	#addi sp,zero,1020 #como comparten la memoria hay que ajustar a esto /4
	add zero,zero,zero
	#parametros adicionales
	addi a6, zero,1 # comparador para el caso base (hay 1 solo disco)
	#--------
	addi n, zero,3 #asiganmos número de discos
	lui t1, 0x10010 #asignamos la direccion de inicio en las torres
	#lui t2, 0x10010 #t1 es la torre destino, t2, la axuliar y t3 la torre final (A, B,C)
	
	
	addi t4, zero, 1 #asignamos una bandera con n-n discos nos sirve más tarde para llenar las torres
	addi a7,zero,0
	FOR:	#sirve para llenar la torre 1 de discos
		sw t4,0(t1) #insertamos un disco en la torre A
		addi t1,t1,0x20 #apuntamos al siguente disco
		addi t4,t4,1 #incrementamos la bandera que nos señala cuantos disco van a faltar
		addi a7,a7,1
		bne a7, n, FOR #regresamos al FOR mientras no haya suficentes discos como n
	
	#el for cicla 1 menos de t4, por lo que debemos llenar un disco adicional
	
	addi t2,t1,0x4 #recorremos abajo y derecha
	#lui t3, 0x10010  #se guarda la zona más baja de la torre
	addi t3,t1,0x8 #abajo y 2 derechas
	#mandar variables a funcion
	lui t1, 0x10010 #regresamos el apuntdor al tope 
	
	addi t4,t1,0xC
	sw t1,0(t4)
	#1000100 apunta a la direccion donde esta aputnado t1
	#addi t5,t4, 0x4
	sw t2,4(t4)
	sw t3,8(t4)
	
	#sw n,t1,t2,t3
	
	#a1,a2,a3 serán apuntadores a los apuntadores de las torres
	#se necesitan estos registros para al momento de regresar, poder mantener la última dirección que se tenía
	#los registros a se usan como parámetros de la función HANOI
	addi a1,t4,0
	addi a2,t4,0x4
	addi a3,t4,0x8
	
	sw a1,0(sp)
	addi sp,sp,-4
	sw a2,0(sp)
	addi sp,sp,-4
	sw a3,0(sp)
	addi sp,sp,-4
	
	jal ra, HANOI 	#llamda a la fucncion HANOI que será recursiva, usamos jal ra para guardar la direccion de retorno
	addi sp,sp,4
	lw a3, 0(sp)
	addi sp,sp,4
	lw a2, 0(sp)
	addi sp,sp,4
	lw a1,0(sp)
	addi sp,sp,4
	jal zero,FIN	#fin del programa
HANOI: 
	
	sw ra, 0(sp) #nos importa guardar la direccion de retorno del stack pointer para saber donde nos quedamos
	addi sp,sp,-4
	
	BASE_CASE:
		bne a6,n, NORMAL_CASE  #checamos que el núemero de discos sea 1 si no, vamos a un NORMAL_CASE
		
		lw s2,0(a1) #la primer direccion de memoria 1001000
		lw a5,0(s2) #cargamos el disco de s2
		
		
		
		#lw a5,0(t1)  #copiamos el disco al registro a5 //se usó un doble apuntador
		sw zero,0(s2) #borramos el disco de la torre 1
		addi s2,s2,0x20 #apuntamos abajo (que en toeria sería deajo de la torre porque solo queda 1 disco)
		sw s2,0(a1)
		#addi t3,t3,-0x20 #apuntamos arriba de la actual dirección de la torre 3
		lw s3,0(a3)
		#apuntamos arriba para poder insertar
		addi s3,s3,-0x20
		sw a5,0(s3) #insertamos el disco en la torre t3 (que cambiaria con las llamadas recursivas)
		sw s3,0(a3)
		#aqui se pone feo el asunto, porque debemos regresar la dirección del stack pointer para saber donde quedamos
		#aqui es donde vamoa a empezar a regresar todo
		addi sp,sp,4
		lw ra,0(sp)  	#obtenemos la última dirección del stack pointer
		#addi sp,sp,4
		#lw n, 0(sp)	#guardamos el número actual de discos
		
		
		jalr zero,ra,0	#retornamos
	NORMAL_CASE: #caso normal, donde existen más de 1 disco en la torre, lo ideal es que aquí siempre se va a entrar, o no habria juego...
		#addi sp,sp-8
		#sw n,4(sp)  #mimso plan, guardamos las direcciones y número de discos para saber cunatos hay en las torres
		
		#aqui se pone turbulento pero es basicamente el intercambio de torres
		# la parte del código en c "towers(nums-1, from,aux,to);"
			
			#t5 es una torre que nos ayudará a guardar otra, pero como ya use t4 pues ni modo
		
	
		#t2=t3
		#t3=t2
		
		
		#addi n,n,-1	#quitamos un disco
		sw n,0(sp)
		addi sp,sp,-4
		sw a1,0(sp)
		addi sp,sp,-4
		sw a2,0(sp)
		addi sp,sp,-4
		sw a3,0(sp)
		addi sp,sp,-4
		addi n,n,-1
		
		add t5,zero,a3 #hacemos un pivot de las torres
		add a3,zero,a2
		add a2,zero,t5
		jal ra, HANOI
		
		#si vamos a mandar datos al sp usando una llamada, es
		#importante sacarlos al terminar cada llamada
		#sacamos el estado de la llamada actual
		addi sp,sp,4
		lw a3, 0(sp)
		addi sp,sp,4
		lw a2, 0(sp)
		addi sp,sp,4
		lw a1,0(sp)
		addi sp,sp,4
		lw n,0(sp)
		
		
		#addi a1,a1,0x20	#apuntamos al siguiente disco
		#lw a5,0(t1)	#quitamos un disco
		#sw zero,0(t1)	#hacemos un borrado
		
		lw s2,0(a1) #la primer direccion de memoria 1001000
		lw a5,0(s2) #cargamos el disco de s2
		#lw a5,0(t1)  #copiamos el disco al registro a5 //se usó un doble apuntador
		sw zero,0(s2) #borramos el disco de la torre 1
		addi s2,s2,0x20 #apuntamos abajo (que en toeria sería deajo de la torre porque solo queda 1 disco)
		sw s2,0(a1)
		#addi t3,t3,-0x20 #apuntamos arriba de la actual dirección de la torre 3
		lw s3,0(a3)
		addi s3,s3,-0x20
		sw a5,0(s3) #insertamos el disco en la torre t3 (que cambiaria con las llamadas recursivas)
		sw s3,0(a3)
		
		#addi,t3,t3,-0x20 	#apuntamos arriba de la actual direccion
		
		#ahora va la segunda parte de la función recursiva
		# del código en c"towers(nums-1, aux,to,from);"
		#cambiamos direcciones y restamos disco
		
		sw n,0(sp)
		addi sp,sp,-4
		sw a1,0(sp)
		addi sp,sp,-4
		sw a2,0(sp)
		addi sp,sp,-4
		sw a3,0(sp)
		addi sp,sp,-4
		addi n,n,-1
		
		
		add t5,zero,a1 #hacemos un pivot de las torres
		add a1,zero,a2
		add a2,zero,t5
		jal ra,HANOI
		
		addi sp,sp,4
		lw a3, 0(sp)
		addi sp,sp,4
		lw a2, 0(sp)
		addi sp,sp,4
		lw a1,0(sp)
		addi sp,sp,4
		lw n,0(sp)
		
		addi sp,sp,4
		lw ra,0(sp) 	#esto sería la primera direccion almacenada en el stack pointer
		#addi sp,sp,4
		#lw n,0(sp) 	#el número de discos amlacenado en el stack pointer
		#addi sp,sp,8	#recorremos a la siguientes direcciones (2 lugares)
		
		#regresamos las torres
		jalr zero,ra,0

FIN:		
		

		
		
		
		
		
		
		
	


