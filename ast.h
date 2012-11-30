#ifndef NODEH
#define NODEH

class GenericNode {
public:
        GenericNode* a;
        GenericNode* b;
        GenericNode* c;
        GenericNode* d;

        int value;
        int node_type;
        
        char * symTp; //Symbol type come from Lexical Analisys
        char * symId; //Symbol ID come from Lexical Analisys

        GenericNode(){}

        GenericNode(GenericNode* A, GenericNode* B, GenericNode* C, GenericNode* D){
        	this->a = A;
        	this->b = B;
        	this->c = C;
        	this->d = D;
        }
        

        void setType(int type){
        	this->node_type = type;
        }
};
#endif