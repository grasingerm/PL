/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package TST;

/**
 *
 * @author clementine
 */
public class TernaryTree<T> {
    private TernaryNode<T> root;
    
    public TernaryTree() {}
    
    public void put(String key, T val) {
        root = put(root, key, val, 0);
    }
    
    private TernaryNode<T> put(TernaryNode<T> node, String key, T val, int idx) {
        char c = key.charAt(idx);
        if (node == null) {
            node = new TernaryNode<T>(c);
        }
        if (c < node.getC())              
            node.setLeft(put(node.getLeft(), key, val, idx));
        else if(c > node.getC())          
            node.setRight(put(node.getRight(), key, val, idx));
        else if(idx == key.length() - 1)  
            node.setValue(val);
        else                              
            node.setMiddle(put(node.getMiddle(), key, val, idx + 1));
        return node;
    }
    
    public TernaryNode<T> get(String key) {
        return get(root, key, 0);
    }
    
    public TernaryNode<T> get(TernaryNode<T> node, String key, int idx) {
        char c = key.charAt(idx);
        if (idx == key.length() - 1) {
            if (node == null || c != node.getC() || node.getValue() == null) 
                return null;
            else return node;
        }
        if (c < node.getC())      return get(node.getLeft(), key, idx);
        else if (c > node.getC()) return get(node.getRight(), key, idx);
        else                      return get(node.getMiddle(), key, idx + 1);
    }
    
    public int getHeight() { return this.root.getHeight(); }
    public int numNodes() { return this.root.numNodes(); }
}
