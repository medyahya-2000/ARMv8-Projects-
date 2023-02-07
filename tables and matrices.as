.include "/root/SOURCES/ift209/tools/ift209.as"
.global MultMatVec


.section ".text"


/***********************************************************************

	MultMatVec

	Effectue la multiplication d'une matrice par un vecteur.



	Entrées:
		(paramètre) x0: adresse de la matrice
		(paramètre) x1: adresse du vecteur
		(paramètre) x2: adresse du vecteur de résultats
		(paramètre) x3: nombre de lignes (ou hauteur)
		(paramètre) x4: nombre de colonnes (ou largeur)



	Sorties:
		(écran)	Affichage de l'opération
		(écran) vecteur résultant (suite d'entiers)



	Auteur:
***********************************************************************/

 // Entier signés de 4 octets

 // le pas d'incrémentation est 4
 // le choix de l'instruction est: lecture : ldrsw  ecriture : strw


MultMatVec:

		SAVE

//une boucle sur les lignes
//sur les colonnes
//dabord une qui parcous la 1ere ligne et qui calcule le 1er R résultant//




		mov		x28,0  // compteur de lignes
mat20:

		mov 	x20,0	//cmpteur de colonnes bornés a x4
		mov		x25,0	//Somme

mat10:

		ldrsw	x21,[x0,x20, lsl 2]		//adresse de base matrice
		ldrsw	x26,[x1,x20, lsl 2]		//adresse de base vecteur

		mul		x27,x26,x21		// on multiplie la 1ere valeure de la matrice avec 1ere valeur vecteur

		add		x25,x27,x25		// ajouter le résultat dans la somme totale

		add		x20,x20,1		// incrémente la colonne pour passer à la colonne d'après
		cmp		x20,x4			// si la colonne < que nb Colonnes, on boucle
		b.lt	mat10


		str 	w25,[x2]		// on affiche le résultat
		add 	x2,x2,4			// on tasse de 2 pour l'Affichage en ligne 'x ,x ,x'

		mov		x29,4		// on change de ligne dans la matrice
		mul		x24,x4,x29	// on change de ligne dans la matrice
		add 	x0,x0,x24	// on change de ligne dans la matrice

					// ici on réussit donc a effectuer le calculer de la 1ere ligne

		// On veux maintenant passer à la ligne suivante

		add		x28,x28,1
		cmp		x28,x3
		b.lt	mat20




		RESTORE
		ret
