#ifndef NODEH
#define NODEH

#include <stdio.h>
#include <stdlib.h>

typedef struct Node TreeNode;
struct Node
{
        TreeNode* a;
        TreeNode* b;
        TreeNode* c;
        TreeNode* d;

        int value;
        int node_type;
};


struct Node *newNode(TreeNode* A,
                 TreeNode* B,
                 TreeNode* C,
                 TreeNode* D);

void setType(TreeNode* _node, int type);

#endif