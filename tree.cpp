void isBST(struct Tree *node) {

  if (node == nullptr) return;

  if (node->left != nullptr && (node->left->data > node->data))
    throw something;
  if (node->right != nullptr && (node->right->data < node->data))
    throw something_else;
  
  isBST(node->left);
  isBST(node->right)
}
