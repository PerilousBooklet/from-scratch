#!/bin/bash
mkdir -vp src/main
cat << EOT > src/main/Main.java
package main;

public class Main {
  
  public static void main(String[] args) {
    System.out.println("Hello there!");
  }
  
}
EOT
