#include <cassert>

typedef struct node {
  int val;
  struct node *left;
  struct node *right;
  int ht;
} node;

node *init_node(int val) {

  node *new_node = new node;

  new_node->val = val;
  new_node->left = nullptr;
  new_node->right = nullptr;
  new_node->ht = 0;
  
  return new_node;
}

node *insert(node *root, int val) {

  assert(root != nullptr);

  node *pcurr = root, *pprev = nullptr;
  while (pcurr != nullptr) {
    pprev = pcurr;
    pcurr = (val >= pcurr->val) ? pcurr->right : pcurr->left;
  }

  node *new_node = init_node(val);
  
  if (val >= pprev->val) 
    pprev->right = new_node;
  else
    pprev->left = new_node;

  return new_node;
}


/* extra code for testing/debugging */

#include <iostream>
using namespace std;

void print_inorder(node *root) {
  if (root != nullptr) {
    print_inorder(root->left);
    cout << "val: " << root->val << "; ht: " << root->ht << '\n';
    print_inorder(root->right);
  }
}

void destroy(node *root) {
  if (root != nullptr) {
    destroy(root->left);
    destroy(root->right);
  }
  delete root;
}

int main() {

  node *root = init_node(5);
  insert(root, 3);
  insert(root, 9);
  insert(root, 11);
  insert(root, 4);
  insert(root, 10);

  print_inorder(root);

  destroy(root);

  return 0;
}
