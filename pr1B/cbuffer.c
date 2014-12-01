#include "cbuffer.h"
#include <stdio.h>

extern void FOO( CBuffer* B, sdump* screen);

void Initialize( CBuffer* B ) {
	B->count  = 0;
	B->start = B->Buffer;
	B->end = B->start;
}

int Full( CBuffer* B ) {
	return B->count == N;
}

int Empty( CBuffer* B ) {
	return B->count == 0;
}

int Insert( CBuffer* B, short int elem )
{
    if( Full( B ) )
    	return -1; // error
    
    *(B->end) = elem;
    B->end++;
    if (B->end >= B->Buffer + N)
    	B->end = B->Buffer;
    B->count++;  
	return 0;  // no hay error
}

int Extract( CBuffer* B, short int* elem ) {
	if( Empty( B ) )
		return -1; // error

	*elem = *(B->start);
	B->start++;
	if (B->start >= B->Buffer + N)
    	B->start = B->Buffer;
	
	B->count--;
	return 0;
}
// En general guarda los valores del Buffer en un array de estructuras sdump
// que tienen guardada la posicion (char que usa como entero de 8 bits) y el valor
void FooC(CBuffer* B, sdump* screen){
	short int i = B->start - B->Buffer, j = 0, end = B->end - B->Buffer;
	while (i != end) {
		screen[j].pos = i;
		screen[j++].value = B->Buffer[i++];
		// Al ser un buffer circular
		if (i >= N)
			i = 0;
	}
}

