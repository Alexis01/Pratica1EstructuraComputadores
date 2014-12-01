#define N 256

typedef struct {
	short int count;
	short int* start;
	short int* end;
	short int Buffer[N];
} CBuffer;

typedef struct{
	char pos;
	short int value;
} sdump;

void Initialize(CBuffer* B );

int Full(CBuffer* B );

int Empty(CBuffer* B );

int Insert(CBuffer* B, short int elem );

int Extract(CBuffer* B, short int* elem);

void FOO (CBuffer* B, sdump* screen);
