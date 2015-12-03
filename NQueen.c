#include <stdio.h>
#include <stdlib.h>

void initializeArray();
void printArray();
int length(char* string);
int value(char* string);
int power(int base, int exponent);
int isSafe(int row, int col);
int solveNQUtil(int col);
int solveNQ();

// Global variables
int inputtedValue;
int **NQBoard;

int main() {

    inputtedValue = 0;

	char greeting[19] = { '\n', 'M', 'I', 'P', 'S', ' ', 'P', 'r', 'o', 'g', 'r', 'a', 'm', ' ', 'B', 'y', ':', ' ', '\0' };
	char name[13] = { 'B', 'r', 'a', 'n', 'd', 'o', 'n', ' ', 'W', 'o', 'n', 'g', '\0' };
	char input[10] = {};

	printf("%s%s%s", greeting, name, "\n\n");
	printf("%s", "Enter a number: ");

	fgets(input, 10, stdin);

	inputtedValue = value(input);

	solveNQ();
	
	free(NQBoard);
	
	return 0;
}

int length(char* string) {
	int count = 0;
	for(int i = 0; i < 100; i++) {
		if(string[i] != '\0' && string[i] != '\n') {
			if((string[i] - '0' > 9) || string[i] == ' ') {
				return count;
			}
			count++;	
		}
	}
	return count;
}

int value(char* string) {
	int value = 0;
	for(int i = length(string)-1; i >=0; i--) {
		value = value + (power(10, i) * (string[length(string)-1-i] - '0'));
	}

	return value;
}

int power(int base, int exponent) {
	
	int value = 1;

	if(exponent != 0)
	{
		for(int i = 1; i <= exponent; i++) {
			value = value * base;		
		}
	}

	return value;
}

void initializeArray() {
    int zero = 0;
	NQBoard = malloc(inputtedValue * sizeof(int*));

    for(int i = 0; i < inputtedValue; i++) {
		*(NQBoard + i) = malloc(inputtedValue * sizeof(int));
    }

	for(int i = 0; i < inputtedValue; i++) {
		for(int j = 0; j < inputtedValue; j++) {
            //printf("%s%i%s%i%s%i%s", "I: ", i, " J: ", j, " Current Value: ", NQBoard[i][j], "\n");
			NQBoard[i][j] = 0;
		}
	}
}

void printArray() {
	printf("%s", "{\n");
	for(int i = 0; i < inputtedValue; i++) {
		for(int j = 0; j < inputtedValue; j++) {
			printf("%d%s", NQBoard[i][j], ", ");
		
		}
		printf("%s", "\n");
	}
	printf("%s", "}\n");
}

int isSafe(int row, int col) {
	int i, j;
	
	for(i = 0; i < col; i++) {
		if(NQBoard[row][i] == 1)
			return 0;
	}
		
	for(i = row, j = col; i >=0 && j >= 0; i--, j--) {
		if(NQBoard[i][j] == 1)
			return 0;
	}		
		
	for(i = row, j = col; j >= 0 && i < inputtedValue; i++, j--) {
		if( NQBoard[i][j] == 1) 
			return 0;
	}
	
	return 1;
}

int solveNQUtil(int col) {
	if(col >= inputtedValue) {
		return 1;
	}
	
	for(int i = 0; i < inputtedValue; i++) {
		// Checking to see if the queen works
		if(isSafe(i, col) == 1) {
			// place the queen 
			NQBoard[i][col] = 1;
			
			// recursive to place rest of the queens
			if(solveNQUtil(col+1)) {
				return 1;
			}
			NQBoard[i][col] = 0; // Backtracking if it does not work
		}
	}
	return 0;
		
}

int solveNQ() {

	if(inputtedValue > 0) {
		initializeArray();

        if( solveNQUtil(0) == 0 ) {
            printf("%s", "Solution does not exist\n");
            return 0;
        }

        printArray();
        return 1;
	} else {
            printf("%s", "Please enter a valid number");
    }
	
    return 0;
}

