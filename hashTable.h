#ifdef  HTABLE
#define HTABLE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASH_SIZE 211


class No {
	public:
		char* data;
		char* type;
		No* next;
};

class Hash {
	private:
		bool isPrime(int number) {
			for (int i=2; i<number; i++) {
				if (number % i == 0) {
					return false;
				}
			}
			return true;	
		};

		int prime(int index) {
			int x = 0;
			for(int i = 0; i < index; i++) {
				x++;
				while(!isPrime(x)) {
					x++;
				}
			}
			return x;
		};
		
	public:
		No* hash[HASH_SIZE];
		char* name;
		Hash * FnList;
		char* fnTp;
		char* args;
		
		Hash() {
			init();
		}
	
		void init() {
			int i;
			for(i = 0; i < HASH_SIZE; i++) {
				hash[i] = NULL;
			}
		}

		void insert(char* data, char* type) {
			No* aux;
			
			int value = 0;
			
			// mapping the position according to the word
			for(int i = 0; i < strlen(data); i++){
				value += ((int) data[i])*prime(i+1);
			}
			do
			int position = (int) value % HASH_SIZE;
			
			aux = (No*) malloc(sizeof(No));
			aux->data = data;
			aux->type = type;
			aux->next = hash[position];
			hash[position] = aux;
		}
};

#endif