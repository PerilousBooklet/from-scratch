#!/bin/bash


TOMCAT_MINOR_VERSION=11
TOMCAT_MAJOR_VERSION=11.0.15
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MINOR_VERSION/v$TOMCAT_MAJOR_VERSION/bin/apache-tomcat-$TOMCAT_MAJOR_VERSION.zip"
TOMCAT_FILE="apache-tomcat-$TOMCAT_MAJOR_VERSION"

SERVLET_API_VERSION=6.1.0
SERVLET_API_URL="https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/$SERVLET_API_VERSION/jakarta.servlet-api-$SERVLET_API_VERSION.jar"

THYMELEAF_VERSION_MINOR=""
THYMELEAF_VERSION_MAJOR=""
THYMELEAF_URL=""

UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/2.2.3/umldoclet-2.2.3.jar"


echo -e "\e[32m[INFO]\e[0m Creating base directories..."
mkdir -v assets
mkdir -vp src/resources/META-INF
mkdir -vp src/web/WEB-INF
mkdir -vp src/web/{html,css,js}
mkdir -vp src/main/{servlet,service,model,controller,validation,authentication}


echo -e "\e[32m[INFO]\e[0m Creating src/web/WEB-INF/web.xml..."
touch src/web/WEB-INF/web.xml
cat << EOT > src/web/WEB-INF/web.xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app
    version="4.0"
    xmlns="http://xmlns.jcp.org/xml/ns/javaee"
    xmlns:javaee="http://xmlns.jcp.org/xml/ns/javaee"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd">
  <display-name>Web Application</display-name>
</web-app>
EOT


echo -e "\e[32m[INFO]\e[0m Creating src/resources/META-INF/beans.xml..."
touch src/resources/META-INF/beans.xml
cat << EOT > src/resources/META-INF/beans.xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="https://jakarta.ee/xml/ns/jakartaee"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/beans_4_1.xsd">

</beans>
EOT


echo -e "\e[32m[INFO]\e[0m Creating src/resources/META-INF/persistence.xml..."
touch src/resources/META-INF/persistence.xml
cat << EOT > src/resources/META-INF/persistence.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence https://jakarta.ee/xml/ns/persistence/persistence_3_2.xsd"
             version="3.2">
    <persistence-unit name="default">

    </persistence-unit>
</persistence>
EOT


echo -e "\e[32m[INFO]\e[0m Creating src/main/servlet/HelloWorldServlet.java..."
cat << EOT > src/main/servlet/HelloServlet.java
package main.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "helloServlet", value = "/hello")
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        // Hello
        PrintWriter out = response.getWriter();
        out.println("<html><body style='display: flex; justify-content: center;'>");
        out.println("<h1>" + message + "</h1>");
        out.println("</body></html>");
    }

    public void destroy() {
      
    }
}
EOT


echo -e "\e[32m[INFO]\e[0m Creating src/web/index.html..."
touch src/web/index.html
cat << EOT > src/web/index.html
<!DOCTYPE html>
<html>
  
  <head>
    <title>PLACEHOLDER</title>
    <!-- CSS -->
    <link rel="stylesheet" href="css/style.css"></link>
    <!-- JS -->
    <script src="js/lib.js"></script>
  </head>
  
  <body>
    
    <a href="/hello"></a>
    
  </body>
  
</html>
EOT


echo -e "\e[32m[INFO]\e[0m Downloading Servlet API..."
wget "$SERVLET_API_URL" --directory-prefix lib/


echo -e "\e[32m[INFO]\e[0m Installing Tomcat $TOMCAT_VERSION..."
wget "$TOMCAT_URL"
unzip "$TOMCAT_FILE".zip
mv "$TOMCAT_FILE" .tomcat
find .tomcat/bin -name '*.sh' -exec chmod +x {} \;
rm -v "$TOMCAT_FILE".zip


echo -e "\e[32m[INFO]\e[0m Install dark theme for javadoc..."
if [[ ! -f .styles ]]; then
  mkdir -v .styles
fi
touch .styles/dark.css
cat << EOT > .styles/dark.css
/* TODO: convert to dark github theme */

/* Created with Javadoc-Themer built by Nishant */
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap');
@import url(//db.onlinewebfonts.com/c/1db29588408eadbd4406aae9238555eb?family=Consolas);body {
    background-color: #ffffff;
    color: #141414;
    font-family: 'Roboto';
    font-size: 76%;
    margin: 0;
}

dl.notes > dd, code, #class-description > div.block {
    font-family: 'Roboto';
}

body > div.flex-box > div > main {
    max-width: 1080px;
    min-width: 800px;
    width: 90%;
    box-shadow: rgba(0, 0, 0, 0.05) 0px 6px 9px 0px;
    border-radius: 5px;
    margin: 0 auto;
    margin-top: 20px;
}

.top-nav {
    background: white;
}

#navbar-top-firstrow > li:child():not(a) {
    background: red;
}

#navbar-top-firstrow > li {
    color: cornflowerblue;
}

.nav-bar-cell1-rev {
    background-color: rgba(0, 0, 0, 0);
    font-weight: bold;
}

/* A - LINKS */
a:link, a, #navbar-top-firstrow > li > a{
    color: cornflowerblue;
    font-weight: normal;
    text-decoration: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0);
}

a:link:visited, a:visited {
    color: cornflowerblue;
    text-decoration: none;
}
a:link:hover, a:hover, 
#navbar-top-firstrow > li > a:hover, 
body > div.flex-box > div > main > div.header > div > a:hover,
body > div.flex-box > header > nav > div.sub-nav > div:nth-child(1) > ul:nth-child(1) > li > a:hover,
#class-description > div.block > a:hover > code,
body > div.flex-box > div > main > div.inheritance > a:hover,
#class-description > div.type-signature > span.extends-implements > a:hover {
    color: cornflowerblue;
    border-bottom: 1px solid cornflowerblue;
}
a:link:focus, a:focus {
    color: cornflowerblue;
    font-weight: bold;
    text-decoration: none;
}
a:link:active, a:active {
    color: #4c6b87;
    text-decoration: none;
}
a[name] {
    color: #141414;
}
a[name]:hover {
    color: #141414;
    text-decoration: none;
}

/* details navigation links */
body > div.flex-box > header > nav > div.sub-nav > div:nth-child(1) > ul:nth-child(2),
body > div.flex-box > header > nav > div.sub-nav > div:nth-child(1) > ul:nth-child(1) > li:nth-child(2), #navbar-top-firstrow > li:nth-child(7),
#class-description > hr,
body > div.flex-box > div > main > div.inheritance {
    display: none;
}
.sub-nav {
    border-top: 1px solid #dfe3e5;
    background-color: white;
    box-shadow: rgba(0, 0, 0, 0.05) 0px 6px 9px 0px;
    float: left;
    overflow: hidden;
    width: 100%;
    
}
#search-input {
    background: white;
    padding: 5px 10px;
    border-radius: 10px;
    border: 1px solid #dfe3e5;
    color: #a3a5a7;
    margin-right: 20px;
    /* box-shadow: rgb(0 0 0 / 5%) 0px 6px 9px 0px; */
}
body > div.flex-box > header > nav > div.sub-nav > div.nav-list-search > label {
    display: none;
}
body > div.flex-box > header > nav > div.sub-nav > div:nth-child(1) {
    margin-top: 2px;
}
#reset-button {
    display:none;
}
.sub-nav div {
    clear: left;
    float: left;
    padding: 0 0 5px 6px;
}


.type-signature, pre {
    background: #f5f8fa; 
    padding: 10px;
    border-radius:6px; 
    font-family: 'Consolas', monospace;
}

section#field-summary, section#constructor-summary, section#method-summary, section#nested-class-summary {
    background: white;
    border: none;
    margin-left: -10px;
}

section#field-detail, section#constructor-detail, section#method-detail,
#field-summary > div.caption,
#constructor-summary > div.caption,
#nested-class-summary > div.caption,
#all-packages-table > div.caption > span,
#class > div.caption > span,
#method > div.caption > span {
    display: none;
}

#field-summary > h2, #constructor-summary > h2, #method-summary > h2, #nested-class-summary > h2 {
    font-style: normal;
}

/* Inheritance declarations */
body.class-declaration-page .summary h3,
body.class-declaration-page .details h3,
body.class-declaration-page .summary .inherited-list h2 {
    background: none;
    border: none;
    font-weight: normal;
    font-size: 15px;
    
}

.table-header, .odd-row-color, .odd-row-color .table-header {
    background: #f5f8fa;
    border: none;
}

.summary-table {
    border: none;
    border-radius: 6px;
}

.summary-table div, body > div.flex-box > div > main > dl > dd > div {
    font-family: 'Roboto';
}

code a:link:not(:hover), .summary-table div > code > a:not(:hover) {
    color: #434c5d;
    border-bottom: 1px solid #b4b4b4;
}

main a[href*="://"]::after {
    display: none;
}

div.table-tabs > button.active-table-tab, #related-package-summary > div.caption > span, #class-summary > div.caption > span {
    background: #f5f8fa;
    color: #434c5d;
    font-weight: normal;
    border-radius: 6px;
    padding-top: 10px;
    border-bottom-left-radius: 0px;
    border-bottom-right-radius: 0px;
    margin-left: 0px;
}
div.table-tabs > button.table-tab {
    background: white;
    color: #434c5d;
    font-weight: normal;
}

.deprecation-block {
    background: #ffe9e9;
    padding: 2px 6px;
    border: none;
    border-radius: 6px;
    font-weight: normal;
    font-family: 'Roboto';
}

#ui-id-1 .ui-state-active {
    background: #f5f8fa;
    border-color: #f5f8fa;
}

#ui-id-1 {
    border-radius: 6px;
    overflow-x: hidden;
    border: none;
}

/* Search results */
ul.ui-autocomplete li {
    background: white;
    color: #434c5d;
    font-family: 'Roboto'
}
EOT


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then
  mkdir -v .tools
fi
wget "$UMLDOCLET_URL" --directory-prefix .tools


echo -e "\e[32m[INFO]\e[0m Create the Lite XL project module"
touch .lite_project.lua
cat << EOT > .lite_project.lua
-- Put the project module settings here.
-- This module will be loaded when opening a project, after the user module
-- configuration.
-- It will be automatically reloaded when saved.

local config = require "core.config"

-- you can add some patterns to ignore files within the project
-- config.ignore_files = {"^%.", <some-patterns>}

-- Patterns are normally applied to the file's or directory's name, without
-- its path. See below about how to apply filters on a path.
--
-- Here some examples:
--
-- "^%." matches any file of directory whose basename begins with a dot.
--
-- When there is an '/' or a '/$' at the end, the pattern will only match
-- directories. When using such a pattern a final '/' will be added to the name
-- of any directory entry before checking if it matches.
--
-- "^%.git/" matches any directory named ".git" anywhere in the project.
--
-- If a "/" appears anywhere in the pattern (except when it appears at the end or
-- is immediately followed by a '$'), then the pattern will be applied to the full
-- path of the file or directory. An initial "/" will be prepended to the file's
-- or directory's path to indicate the project's root.
--
-- "^/node_modules/" will match a directory named "node_modules" at the project's root.
-- "^/build.*/" will match any top level directory whose name begins with "build".
-- "^/subprojects/.+/" will match any directory inside a top-level folder named "subprojects".

-- You may activate some plugins on a per-project basis to override the user's settings.
-- config.plugins.trimwitespace = true


-- Override lsp_java configuration to give jdtls my custom path for libs

EOT
