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
public class TernaryNode<T> {
    private char c;
    private T val;
    private TernaryNode<T> left;
    private TernaryNode<T> middle;
    private TernaryNode<T> right;
    
    public TernaryNode(char c) {
        this.c = c;
    }
    
    public TernaryNode(char c, T val) {
        this.c = c;
        this.val = val;
    }
    
    public TernaryNode(char c, TernaryNode<T> left, TernaryNode<T> middle,
                       TernaryNode<T> right) {
        this.c = c;
        this.left = left;
        this.middle = middle;
        this.right = right;
    }
    
    public TernaryNode(char c, T val, TernaryNode<T> left, 
                       TernaryNode<T> middle,
                       TernaryNode<T> right) {
        this.c = c;
        this.val = val;
        this.left = left;
        this.middle = middle;
        this.right = right;
    }
    
    public char getC()              { return this.c;    }
    public T getValue()             { return this.val;  }
    public void setValue(T val)     { this.val = val;   }
    
    public TernaryNode getLeft()    { return this.left; }
    public TernaryNode getMiddle()  { return this.middle; }
    public TernaryNode getRight()   { return this.right; }
    public void setLeft(TernaryNode node)    { this.left = node; }
    public void setMiddle(TernaryNode node)  { this.middle = node; }
    public void setRight(TernaryNode node)   { this.right = node; }
    
    public int getHeight() {
        int leftHeight = 0;
        int middleHeight = 0;
        int rightHeight = 0;
        
        if (this.left != null) {
            leftHeight = this.left.getHeight();
        }
        if (this.middle != null) {
            middleHeight = this.middle.getHeight();
        }
        if (this.right != null) {
            rightHeight = this.right.getHeight();
        }
        
        return 1 + Math.max(leftHeight, Math.max(middleHeight, rightHeight));
    }
    
    public int numNodes() {
        int nleft = 0;
        int nmiddle = 0;
        int nright = 0;
        
        if (this.left != null) { nleft = this.left.numNodes(); }
        if (this.middle != null) { nmiddle = this.middle.numNodes(); }
        if (this.right != null) { nright = this.right.numNodes(); }
        
        return 1 + nleft + nmiddle + nright;
    }
 }