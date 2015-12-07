#include "stdafx.h"
#include <iostream>
#include <cstdio>
#include <cstdlib>
using namespace std;

int solveNQUtil(int *board, int column, int size) {
	if (column == size)
		return 1;
	for (int i = 0; i < size; i++) {
		int j, k;
		int isSafe = 1;
		for (j = 0; j < column; j++)
			if (board[i * size + j] == 1)
				isSafe = 0;
		for (j = i, k = column; j > -1 && k > -1; j--, k--)
			if (board[j * size + k] == 1)
				isSafe = 0;
		for (j = i, k = column; k > -1 && j < size; j++, k--)
			if (board[j * size + k] == 1)
				isSafe = 0;
		if (isSafe == 1) {
			board[i * size + column] = 1;
			if (solveNQUtil(board, column + 1, size) == 1)
				return 1;
			board[i * size + column] = 0;
		}
	}
	return 0;
}

int main() {
	int size;
	cout << "Enter the board width.\n";
	cin >> size;
	int *board = (int*)malloc(sizeof(int) * (size * size));
	for (int i = 0; i < (size * size); i++)
		board[i] = 0;
	if (solveNQUtil(board, 0, size) == 0) {
		cout << "No solution exists" << endl;
		return false;
	}
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++)
			cout << board[i * size + j] << "  ";
		cout << endl;
	}
	return 0;
}


