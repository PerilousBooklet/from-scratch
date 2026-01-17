#!/bin/bash

UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/2.2.3/umldoclet-2.2.3.jar"

mkdir -vp src/main

echo -e "\e[32m[INFO]\e[0m Creating Main.java..."
cat << EOT > src/main/Main.java
package main;

import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class Main {
  
  public static void main(String[] args) {
    try {
      // Create an HttpServer instance
      HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
      
      // Create a context for a specific path and set the handler
      server.createContext("/", new MyHandler());
      
      // Start the server
      server.setExecutor(null); // Use the default executor
      server.start();
      
      System.out.println("Server is running on port 8000");
    } catch (IOException e) {
      System.out.println("Error starting the server: " + e.getMessage());
    }
  }
    
  // Define a custom HttpHandler
  static class MyHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
      // Handle the request
      String response = "Hello, this is a simple HTTP server response!";
      exchange.sendResponseHeaders(200, response.length());
      OutputStream os = exchange.getResponseBody();
      os.write(response.getBytes());
      os.close();
    }
  }
  
}
EOT

echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then
  mkdir -v .tools
fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
