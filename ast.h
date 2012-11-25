
#include <iostream>
#include <string.h>

#ifndef ASTH
#define ASTH

class Node
{
	public:
		int value;
		char* symbol;
		Node* a; 
		Node* b;
		
		Node()
		{
			this->a = NULL;
			this->b = NULL;
			this->symbol = NULL;
		}


		virtual void RPN()
		{
			if(a)
			{
				a->RPN();
			}
			if(b)
			{
				b->RPN();
			}
		}
};

class Or_logical_expression_aux : public Node
{
public:
	Node* c;
	Node* d;
	void RPN()
	{
		Node::RPN();
		if(c)
		{
			c->RPN();	
		}
		if(d)
		{
			d->RPN();
		}
			std::cout << "Or_logical_expression_aux ";

	}
};




class And_logical_expression_aux : public Node
{
public:
	Node* c;
	void RPN()
	{
		Node::RPN();
		if(c)
		{
			c->RPN();	
		}
			std::cout << "And_logical_expression_aux ";

	}
};

class Or_expression_aux : public Node
{
	public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();
			}
			std::cout << "Or_expression_aux ";
		}
};

class Xor_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Xor_expression_aux ";
		}
};

class And_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "And_expression_aux ";
		}
};

class Relational_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Relational_expression_aux ";
		}
};

class Shift_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Shift_expression_aux ";
		}
};
class Conditional_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Conditional_expression ";
		}
};
class Or_logical_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Or_logical_expression ";
		}
};
class Multiplicative_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Multiplicative_expression ";
		}
};

class Additive_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Additive_expression ";
		}
};

class Shift_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Shift_expression ";
		}
};

class Relational_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Relational_expression ";
		}
};

class Equality_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();

			std::cout << "Equality_expression ";
		}
};


class Equality_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Equality_expression ";
		}
};

class And_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "And_expression ";
		}
};

class Xor_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "xor_expression ";
		}
};

class Or_expression : public Node
{
public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();	
			}
				std::cout << "Or_expression ";
		}
};

class And_logical_expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "And_logical_expression ";
		}
};

class Program : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Program ";
		}
};

class Conditional_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Conditional_expression_aux ";
		}
};

class Expression : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Expression ";
		}
};

class Unary_expression_identifier_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Unary_expression_identifier_aux ";
		}

};
class Unary_expression_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Unary_expression_aux ";
		}

};

class Program_aux : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			std::cout << "Program_aux ";
		}

};
class Unary_expression_identifier_aux2 : public Node
{
	public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();	
			}
			std::cout << "Unary_expression_identifier_aux2 ";
		}
};

class Unary_expression : public Node
{
	public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();	
			}
			std::cout << "Unary_expression ";
		}
};
class Pos_identifier : public Node
{
	public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();	
			}
			std::cout << "Pos_identifier ";
		}
};

class Declaration : public Node
{
	public:
		Node* c;
		void RPN()
		{
			Node::RPN();
			if(c)
			{
				c->RPN();	
			}
			std::cout << "Declaration ";
		}
};
class VariableDeclaration : public Node
{
	public:
	Node *a;
	Node *c;
	 void RPN()
	{
		Node::RPN();
		if(c)
			c->RPN();
		std::cout << "Variable_declaration ";
	}
};

class Identifier_expression_aux : public Node{
	public:
	Node* c;
	 void RPN()
	{
		Node::RPN();
		if(c)
			c->RPN();
		std::cout << "Identifier_expression_aux ";
	}
};

class Expression_aux : public Node
{
	public:
	Node* c;
	 void RPN()
	{
		Node::RPN();
		if(c)
			c->RPN();
		std::cout << "Expression_aux ";
	}
};
class Leaf : public Node
{
	public:
		void RPN()
		{
			Node::RPN();
			if(this->symbol != NULL)	
				std::cout << this->symbol << " " ;
			else
				std::cout << this->value << " ";
		}
};


class K1 : public Node
{
public:
	Node * bot;
	void RPN(){

	}

	/* data */
};


class Function : public Node{
public:
	Node * a;
	Node *b;
	Node *c;
	Node *d;
	void RPN(){

	};

};

class I2 : public Node{
public:
  void RPN(){

  }

};


class I1 : public Node
{
public:
	void RPN(){

	}
	/* data */
};


class PrototypeDeclaration : public Node
{
public:
	Node *a;
	Node *b;
	Node *c;
	void RPN(){

	}

	/* data */
};

class H1 : public Node
{
public:
	Node *a;
	Node *b;
	Node *c;
	void RPN(){

	}

	/* data */
};


class Identifier : public Node
{
public:

	void RPN(){
	};
};

class UnaryExpression : public Node
{
public:
	void RPN(){};
	/* data */
};

class A12 : public Node
{
public:

	void RPN(){
	};

};

class F : public Node
{
public:

	void RPN(){
	};

};

class D : public Node
{
public:
	void RPN(){

	}
};


class E : public Node
{
public:
	void RPN(){

	}
};

class C : public Node
{
public:
	void RPN(){

	}
};

class J : public Node
{
public:
	void RPN(){

	}
};

class H : public Node
{
public:
	void RPN(){

	}
};


class G : public Node
{
public:
	void RPN(){

	}
};


class L : public Node
{
public:
	void RPN(){

	}
};


class K : public Node
{
public:
	void RPN(){

	}
};

class N : public Node
{
public:
	void RPN(){

	}
};

class R : public Node
{
public:
	void RPN(){

	}
};

class P : public Node
{
public:
	void RPN(){

	}
};

class V : public Node
{
public:
	void RPN(){

	}
};

class S : public Node
{
public:
	void RPN(){

	}
};


class T : public Node
{
public:
	void RPN(){

	}
};

class O : public Node
{
public:
	void RPN(){

	}
};

class Z4 : public Node
{
public:
	void RPN(){

	}
};

class Y4 : public Node
{
public:
	void RPN(){

	}
};

class Z2 : public Node
{
public:
	void RPN(){

	}
};

class Y1 : public Node
{
public:
	void RPN(){

	}
};

class X1 : public Node
{
public:
	void RPN(){

	}
};


class Z1 : public Node
{
public:
	void RPN(){

	}
};

class X : public Node
{
public:
	void RPN(){

	}
};


class X2 : public Node
{
public:
	void RPN(){

	}
};


class Y : public Node
{
public:
	void RPN(){

	}
};

class Z : public Node
{
public:
	void RPN(){

	}
};

class Y2 : public Node
{
public:
	void RPN(){

	}
};

class X3 : public Node
{
public:
	void RPN(){

	}
};

class Z3 : public Node
{
public:
	void RPN(){

	}
};


class X4 : public Node
{
public:
	void RPN(){

	}
};

class Y3 : public Node
{
public:
	void RPN(){

	}
};

class A1 : public Node
{
public:
	Node * c;
	void RPN(){

	}
};















































#endif