#include "cbuffer.h"
extern sdump screen[];
CBuffer B;
 

int Main(void)
{
	short int i;
	
	Initialize( &B );
	
	for(i = 0 ; i < 10 ; i++ ) {
		Insert( &B, i );
	}
    
	FOO( &B, screen );
	
	while(!Empty(&B)) {
		Extract( &B, &i );
	}
			
	return 0;
}
