#!/bin/bash


JAVA_VERSION=21


####################################
## Generate Java project template ##
####################################

PROJECT_NAME="${1:-mywebapp}"

echo "Creating Java Servlet project: $PROJECT_NAME"

# Root structure
mkdir -p "$PROJECT_NAME"/{src,lib,webapp/WEB-INF,target}

# Download Servlet API
wget \
    "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar" \
    --directory-prefix "${PROJECT_NAME}/lib/"

# WEB-INF essentials
cat > "$PROJECT_NAME/webapp/WEB-INF/web.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">
    
    <display-name>My Web Application</display-name>
    
</web-app>
EOF

# Sample servlet with @WebServlet annotation
cat > "$PROJECT_NAME/src/HelloServlet.java" << 'EOF'
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Hello Servlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Hello from Servlet!</h1>");
            out.println("<p>This servlet is working correctly!</p>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
EOF

# Sample index page
cat > "$PROJECT_NAME/webapp/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome</title>
</head>
<body>
    <h1>Servlet Application</h1>
    <p><a href="hello">Try the Hello Servlet</a></p>
</body>
</html>
EOF

# Build script - THIS IS THE KEY FIX
cat > "$PROJECT_NAME/build.sh" << 'EOF'
#!/bin/bash
set -e

# Clean target directory
echo "Cleaning target directory..."
rm -rf target/*

# Create proper WAR structure
echo "Creating WAR structure..."
mkdir -p target/WEB-INF/classes
mkdir -p target/WEB-INF/lib

# Compile Java sources
echo "Compiling Java sources..."
javac -d target/WEB-INF/classes -cp "lib/*" src/*.java

# Copy webapp content (HTML, CSS, JS, etc.)
echo "Copying webapp content..."
cp webapp/index.html target/

# Copy WEB-INF/web.xml
echo "Copying WEB-INF configuration..."
cp webapp/WEB-INF/web.xml target/WEB-INF/

# Create WAR file
echo "Creating WAR archive..."
cd target
jar -cvf ../app.war *
cd ..

echo "Build complete: app.war"

echo -e "\e[32m[INFO]\e[0m Deploying WAR file to Tomcat..."
# Remove old deployment
rm -rf ../.tomcat/apache-tomcat-11.0.7/webapps/ROOT
rm -f ../.tomcat/apache-tomcat-11.0.7/webapps/ROOT.war

# Copy new WAR (Tomcat will auto-extract it to ROOT/)
cp "app.war" "../.tomcat/apache-tomcat-11.0.7/webapps/ROOT.war"

echo "Deployment complete. Restart Tomcat to see changes."
EOF

chmod +x "$PROJECT_NAME/build.sh"

# Add README for lib folder
cat > "$PROJECT_NAME/lib/README.txt" << 'EOF'
Place servlet-api.jar here for compilation.
Note: servlet-api.jar should NOT be included in the WAR - Tomcat provides it.

For Jakarta Servlet 6.0 (Tomcat 10+):
https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar
EOF

echo "Project structure created successfully."
echo "Directory tree:"
tree "$PROJECT_NAME" 2>/dev/null || find "$PROJECT_NAME" -print


####################
## Install Tomcat ##
####################

TOMCAT_VERSION=11.0.7
TOMCAT_VERSION_MAJOR=11
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_VERSION_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.zip"


if [[ ! -d .tomcat ]]; then mkdir -vp .tomcat; fi

echo -e "\e[32m[INFO]\e[0m Downloading Tomcat $TOMCAT_VERSION..."
wget "$TOMCAT_URL" --directory-prefix "./.tomcat/"


echo -e "\e[32m[INFO]\e[0m Unpacking Tomcat $TOMCAT_VERSION..."
unzip "./.tomcat/apache-tomcat-$TOMCAT_VERSION.zip" -d "./.tomcat/"

echo -e "\e[32m[INFO]\e[0m Setting x permissions to bin/catalina.sh..."
chmod +x ./.tomcat/apache-tomcat-$TOMCAT_VERSION/bin/catalina.sh

# TODO: write start/stop scripts
# NOTE: place content of CATALINA_BASE in every script

echo -e "\e[32m[INFO]\e[0m Creating Tomcat logs folder..."
mkdir -v ./.tomcat/.apache-tomcat-$TOMCAT_VERSION-logs


#############################
## Generate Tomcat scripts ##
#############################


echo -e "\e[32m[INFO]\e[0m Create ./tomcat_start.sh..."
cat << EOT > ./tomcat_start.sh
#!/bin/bash
JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH
TOMCAT_VERSION=11.0.7
CATALINA_HOME=./.tomcat/apache-tomcat-"\$TOMCAT_VERSION"
CATALINA_BASE=""
"\$CATALINA_HOME"/bin/catalina.sh start -Dcatalina.home="\$CATALINA_HOME" -Dcatalina.base="\$CATALINA_BASE"
EOT
chmod +x ./tomcat_start.sh


echo -e "\e[32m[INFO]\e[0m Create ./tomcat_stop.sh..."
cat << EOT > ./tomcat_stop.sh
#!/bin/bash
JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH
TOMCAT_VERSION=11.0.7
CATALINA_HOME=./.tomcat/apache-tomcat-"\$TOMCAT_VERSION"
"\$CATALINA_HOME"/bin/catalina.sh stop -Dcatalina.home="\$CATALINA_HOME"
EOT
chmod +x ./tomcat_stop.sh


echo -e "\e[32m[INFO]\e[0m Create ./tomcat_restart.sh..."
cat << EOT > ./tomcat_restart.sh
#!/bin/bash
JAVA_VERSION=21
export JAVA_HOME=/usr/lib/jvm/java-$JAVA_VERSION-openjdk
export PATH=$JAVA_HOME/bin:$PATH
TOMCAT_VERSION=11.0.7
CATALINA_HOME=./.tomcat/apache-tomcat-"\$TOMCAT_VERSION"
CATALINA_BASE=""
"\$CATALINA_HOME"/bin/catalina.sh stop -Dcatalina.home="\$CATALINA_HOME" -Dcatalina.base="\$CATALINA_BASE"
"\$CATALINA_HOME"/bin/catalina.sh start -Dcatalina.home="\$CATALINA_HOME" -Dcatalina.base="\$CATALINA_BASE"
EOT
chmod +x ./tomcat_restart.sh


# echo -e "\e[32m[INFO]\e[0m Create ./tomcat_reload.sh..."
# cat << EOT > ./tomcat_reload.sh

# EOT
# chmod +x ./tomcat_reload.sh


# echo -e "\e[32m[INFO]\e[0m Create ./tomcat_start_debug.sh..."
# cat << EOT > ./tomcat_start_debug.sh

# EOT
# chmod +x ./tomcat_start_debug.sh


# echo -e "\e[32m[INFO]\e[0m Create ./tomcat_restart_debug.sh..."
# cat << EOT > ./tomcat_restart_debug.sh

# EOT
# chmod +x ./tomcat_restart_debug.sh


# echo -e "\e[32m[INFO]\e[0m Create ./tomcat_reload_debug.sh..."
# cat << EOT > ./tomcat_reload_debug.sh

# EOT
# chmod +x ./tomcat_reload_debug.sh
