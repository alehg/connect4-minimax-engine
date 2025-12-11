/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package librerias;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JPanel;


public class ImagePanel extends JPanel {

  private Image img;
  private int[][] coord;

  public ImagePanel(String img) {
    this(new ImageIcon(img).getImage());
  }

  public ImagePanel(Image img) {
    this.img = img;
    Dimension size = new Dimension(img.getWidth(null), img.getHeight(null));
    setPreferredSize(size);
    setMinimumSize(size);
    setMaximumSize(size);
    setSize(size);
    setLayout(null);
    coord=new int[0][0];
  }
  
  public ImagePanel(Image img, int[][] coord){
      
      this(img);
      this.coord=coord;
      
  }

  public void paintComponent(Graphics g) {
    g.drawImage(img, 0, 0, null);
    for(int i=0;i<coord.length-1;i++){
        g.setColor(Color.blue);
        Graphics2D gr= (Graphics2D) g;
        gr.setStroke(new BasicStroke(5));
        g.drawLine(coord[i][0], coord[i][1],coord[i+1][0], coord[i+1][1]);
    }
    if(coord.length>1){
        Graphics2D gr1= (Graphics2D) g;
        gr1.setStroke(new BasicStroke(8));
        
        g.setColor(Color.yellow);
        g.drawLine(coord[0][0],coord[0][1],coord[0][0],coord[0][1]);
        g.setColor(Color.green);
        g.drawLine(coord[coord.length-1][0],coord[coord.length-1][1],coord[coord.length-1][0],coord[coord.length-1][1]);
    }
  }


    public int[][] getCoord() {
        return coord;
    }

    public void setCoord(int[][] coord) {
        this.coord = coord;
    }
  
  
}
