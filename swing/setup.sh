#!/bin/bash
mkdir -vp src/main
cat << EOT > src/main/Main.java
package main;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.Toolkit;

import javax.swing.JFrame;
import javax.swing.JPanel;

public class Main {

  public static final int appWidth = 1600;
  public static final int appHeight = 900;
  
  public static final Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
  public static final int screenWidth = (int) screenSize.getWidth();
  public static final int screenHeight = (int) screenSize.getHeight();
  
  public static JFrame frame = new JFrame("Desktop App");
  public static final JPanel panelTop = new JPanel();
  public static final JPanel panelBottom = new JPanel();
  public static final JPanel panelCenter = new JPanel();
  public static final JPanel panelLeft = new JPanel();
  public static final JPanel panelRight = new JPanel();
  private static final BorderLayout layoutMain = new BorderLayout();
  
	private static void createAndShowUI() {
		//Create and set the window
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    
    //Set the content pane
    Container contentPane = frame.getContentPane();
    contentPane.setLayout(layoutMain);

    // Assign panel properties
    panelTop.setBackground(Color.ORANGE);
    panelTop.setPreferredSize(new Dimension(30, 30));
    panelBottom.setBackground(Color.RED);
    panelBottom.setPreferredSize(new Dimension(30, 30));
    panelCenter.setBackground(Color.GRAY);
    panelCenter.setPreferredSize(new Dimension(30, 30));
    panelLeft.setBackground(Color.PINK);
    panelLeft.setPreferredSize(new Dimension(30, 30));
    panelRight.setBackground(Color.GREEN);
    panelRight.setPreferredSize(new Dimension(30, 30));
    
    // Assemble the base UI
    frame.add(panelTop, BorderLayout.NORTH);
    frame.add(panelBottom, BorderLayout.SOUTH);
    frame.add(panelCenter, BorderLayout.CENTER);
    frame.add(panelLeft, BorderLayout.WEST);
    frame.add(panelRight, BorderLayout.EAST);
    
    //Display the window
    frame.pack();
    frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
    frame.setBounds(
      screenWidth/2 - appWidth/2, 
      screenHeight/2 - appHeight/2, 
      appWidth, 
      appHeight
    );
    frame.setResizable(true);
    frame.setVisible(true);
    
	}
  
  public static void main(String args[]) {
    javax.swing.SwingUtilities.invokeLater(
      new Runnable() {
        public void run() {
          createAndShowUI();
        }
      }
    );
	}
  
}
EOT
