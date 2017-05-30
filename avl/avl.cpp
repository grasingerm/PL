#include <cassert>
#include <algorithm>
#include <iostream>
using namespace std;

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
  new_node->ht = 1;
  
  return new_node;
}

inline int _ht(const node *root) {
  return (root == nullptr) ? -1 : max(_ht(root->left), _ht(root->right)) + 1; 
}

inline int ht(const node *root) {
  return (root == nullptr) ? -1 : root->ht;
}

inline int bf(const node &root) {
  return (ht(root.left) - ht(root.right));
}

inline int bf(const node *root) {
  assert(root != nullptr);
  return (ht(root->left) - ht(root->right));
}

void update_hts(node *root) {
  if (root != nullptr) {
    root->ht = _ht(root);
    update_hts(root->left);
    update_hts(root->right);
  }
}

node *right_rotate(node *pivot) {
  node *left = pivot->left;
  node *lr = left->right;

  pivot->left = lr;
  left->right = pivot;

  pivot->ht = max(_ht(pivot->left), _ht(pivot->right)) + 1;
  left->ht = max(_ht(left->left), _ht(left->right)) + 1;

  return left;
}

node *left_rotate(node *pivot) {
  node *right = pivot->right;
  node *rl = right->left;

  pivot->right = rl;
  right->left = pivot;

  pivot->ht = max(_ht(pivot->left), _ht(pivot->right)) + 1;
  right->ht = max(_ht(right->left), _ht(right->right)) + 1;

  return right;
}

node *insert(node *root, int val) {

  if (root == nullptr)
    return init_node(val);

  if (val < root->val)
    root->left = insert(root->left, val);
  else if (val >= root->val)
    root->right = insert(root->right, val);
  
  root->ht = max(_ht(root->left), _ht(root->right)) + 1;
  int bf_root = bf(root);

  if (bf_root > 1 && val < root->left->val)
    return right_rotate(root);

  if (bf_root < -1 && val > root->right->val)
    return left_rotate(root);

  if (bf_root > 1 && val > root->left->val) {
    root->left = left_rotate(root->left);
    return right_rotate(root);
  }
  
  if (bf_root < -1 && val < root->right->val) {
    root->right = right_rotate(root->right);
    return left_rotate(root);
  }

  return root;
}

/* extra code for testing/debugging */

void print_inorder(const node *root) {
  if (root != nullptr) {
    print_inorder(root->left);
    cout << "val: " << root->val << "; ht: " << root->ht << "; bf: " 
         << bf(*root) << '\n';
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

  node *root = init_node(3);
  root = insert(root, 2);
  root = insert(root, 4);
  root = insert(root, 5);
  root = insert(root, 6);

  print_inorder(root);

  destroy(root);

  return 0;
}
