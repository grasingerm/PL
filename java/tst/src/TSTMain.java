/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import TST.TernaryNode;
import TST.TernaryTree;
import TST.Test;

/**
 *
 * @author clementine
 */
public class TSTMain {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        TernaryNode<Integer> node = new TernaryNode<>('a', 3);
        Test t1 = new Test();
        Test t2 = new Test(2.3, 1.2);
        System.out.println(t1.getX());
        System.out.println(t1.getY());
        System.out.println(t2.getX());
        System.out.println(t2.getY());
        System.out.println(node.getC());
        System.out.println(node.getValue());
        
        TernaryTree<Integer> tree = new TernaryTree<>();
        tree.put("poop", 1);
        tree.put("pee", 2);
        tree.put("red", 9);
        
        System.out.println(tree.getHeight());
        System.out.println(tree.numNodes());
        TernaryNode<Integer> tnode = tree.get("poop");
        if (tnode != null) System.out.println(node.getValue());
        else System.out.println("poop not found.");
        
        tnode = tree.get("pee");
        if (tnode != null) System.out.println(node.getValue());
        else System.out.println("pee not found.");
        
        tnode = tree.get("blue");
        if (tnode != null) System.out.println(node.getValue());
        else System.out.println("blue not found.");
    }
    
}
