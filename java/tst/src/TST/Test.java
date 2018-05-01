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
public class Test {
    private double x;
    private double y;
    
    public Test() {
        this.x = 0.0;
        this.y = 0.0;
    }
    
    public Test(double x, double y) {
        this.x = x;
        this.y = y;
    }
    
    public double getX() { return this.x; }
    public double getY() { return this.y; }
}
