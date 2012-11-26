#include "node.h"

struct Node *newNode(TreeNode* A, TreeNode* B, TreeNode* C, TreeNode* D)
{
        TreeNode* aux = (TreeNode*)malloc(sizeof(struct Node));
        aux->a = A;
        aux->b = B;
        aux->c = C;
        aux->d = D;
        aux->node_type = 0;
        return aux;
}

void setType(TreeNode* _node, int type)
{
        _node->node_type = type;
}

