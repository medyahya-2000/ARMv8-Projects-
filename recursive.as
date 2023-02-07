.include "/root/SOURCES/ift209/tools/ift209.as"

.global Compile


.section ".text"

/********************************************************************************
*																				*
*	Sous-programme qui compile un arbre syntaxique et produit le code binaire  	*
*	des instructions.															*
*																				*
*	Paramètres:																	*
*		x0: adresse du noeud racine												*
*		x1: adresse du tableau d'octets pour écrire le code compilé				*
*															                    *
*	Auteurs: Mohamed Yahya, Antoine Legros
																		*
*																				*
********************************************************************************/

Compile:                    // coquille
	SAVE
	mov   x2,0             //compteur d'octet
    bl  CompileRec         //la fonction recursive

	adr   x22,write         //chercher la valeur
	ldrb  w23,[x22]         //lire la valeur
	strb  w23,[x1],1        //ecrire la valeur

	add   x2,x2,2           //Incrementer le compteur d'octet de 2
	mov    x0,x2            //Mettre le nombre d'instruction dans x0

	RESTORE
	ret

CompileRec:
    SAVE
    mov     x19,x0
    ldr     w20,[x19]        //Charger 8 bits
	cmp     w20,0            //si le noeud est une feuille
	b.eq    comp10           //lire un nombre


    ldr     x0,[x19,8]       //voir l'enfant gauche
	bl      CompileRec

	ldr     x0,[x19,16]      //voir l'enfant droite
    bl      CompileRec



	ldr     w21,[x19,4]      // lire le noeud
compOper:

	cmp     x21,0           //condtion d'addition
	b.ne    compSub
	adr     x22,add          //addition
	ldrb    w23,[x22]        //lire la valeur
	strb    w23,[x1],1		// ecrire la valeur
	add     x2,x2,1        //incremente le compteur d'octet

compSub:

	cmp     x21,1          //condtion de soustraction
	b.ne    compMul
	adr     x22,sub			// soustraction
	ldrb    w23,[x22]      //lire la valeur
	strb    w23,[x1],1	   // ecrire la valeur
	add     x2,x2,1        //incremente le compteur d'octet

compMul:

	cmp     x21,2        //condition de multiplication
	b.ne    compDiv
	adr     x22,mul			// multiplication
	ldrb    w23,[x22]		//lire la valeur
	strb    w23,[x1],1		// ecrire la valeur
	add     x2,x2,1        //incremente le compteur d'octet

compDiv:

	cmp     x21,3           //condition de division
	b.ne    fin
	adr     x22,div			//division
	ldrb    w23,[x22]       //lire la valeur
	strb    w23,[x1],1		// ecrire la valeur
	add     x2,x2,1			//incremente le compteur d'octet
fin:
    b.al    compFin

comp10:
    adr    x22,push		   //Charger l'adresse du push et le stoker sur la pile
	ldrb   w23,[x22]		
	strb   w23,[x1],1

	ldrb   w23,[x19,5]		//Charger le nombre et le stoker sur la pile
	strb   w23,[x1],1

	ldrb   w23,[x19,4]
	strh   w23,[x1],1

	add     x2,x2,3        //incremente le compteur d'octet



compFin:
	RESTORE
	ret


	.section ".data"

	write:   .hword  0x21
	push:    .byte	0x40
	add:     .byte	0x48
	sub:     .byte	0x4C
	mul:     .byte	0x50
	div:     .byte	0x54
