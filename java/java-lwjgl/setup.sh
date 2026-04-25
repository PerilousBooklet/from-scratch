#!/bin/bash
set -e


JAVA_VERSION=21

LWJGL_VERSION=3.3.6
LWJGL_URL="https://github.com/LWJGL/lwjgl3/releases/download/$LWJGL_VERSION/lwjgl-$LWJGL_VERSION.zip"
LWJGL_FILE="lwjgl-$LWJGL_VERSION"

UMLDOCLET_VERSION=2.2.3
UMLDOCLET_URL="https://github.com/talsma-ict/umldoclet/releases/download/$UMLDOCLET_VERSION/umldoclet-$UMLDOCLET_VERSION.jar"


echo -e "\e[32m[INFO]\e[0m Creating src/main and lib folders..."
mkdir -vp src/main
mkdir -v lib


echo -e "\e[32m[INFO]\e[0m Writing src/main/Main.java..."
cat << EOT > src/main/Main.java
package main;

import org.lwjgl.*;
import org.lwjgl.glfw.*;
import org.lwjgl.opengl.*;
import org.lwjgl.system.*;

import java.nio.*;

import static org.lwjgl.glfw.Callbacks.*;
import static org.lwjgl.glfw.GLFW.*;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.system.MemoryStack.*;
import static org.lwjgl.system.MemoryUtil.*;

public class Main {

	// The window handle
	private long window;

	public void run() {
		System.out.println("Hello LWJGL " + Version.getVersion() + "!");

		init();
		loop();

		// Free the window callbacks and destroy the window
		glfwFreeCallbacks(window);
		glfwDestroyWindow(window);

		// Terminate GLFW and free the error callback
		glfwTerminate();
		glfwSetErrorCallback(null).free();
	}

	private void init() {
		// Setup an error callback. The default implementation
		// will print the error message in System.err.
		GLFWErrorCallback.createPrint(System.err).set();

		// Initialize GLFW. Most GLFW functions will not work before doing this.
		if ( !glfwInit() )
			throw new IllegalStateException("Unable to initialize GLFW");

		// Configure GLFW
		glfwDefaultWindowHints(); // optional, the current window hints are already the default
		glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE); // the window will stay hidden after creation
		glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE); // the window will be resizable

		// Create the window
		window = glfwCreateWindow(1600, 900, "This is LWJGL!", NULL, NULL);
		if ( window == NULL )
			throw new RuntimeException("Failed to create the GLFW window");

		// Setup a key callback. It will be called every time a key is pressed, repeated or released.
		glfwSetKeyCallback(window, (window, key, scancode, action, mods) -> {
			if ( key == GLFW_KEY_ESCAPE && action == GLFW_RELEASE )
				glfwSetWindowShouldClose(window, true); // We will detect this in the rendering loop
		});

		// Get the thread stack and push a new frame
		try ( MemoryStack stack = stackPush() ) {
			IntBuffer pWidth = stack.mallocInt(1); // int*
			IntBuffer pHeight = stack.mallocInt(1); // int*

			// Get the window size passed to glfwCreateWindow
			glfwGetWindowSize(window, pWidth, pHeight);

			// Get the resolution of the primary monitor
			GLFWVidMode vidmode = glfwGetVideoMode(glfwGetPrimaryMonitor());

			// Center the window
			glfwSetWindowPos(
				window,
				(vidmode.width() - pWidth.get(0)) / 2,
				(vidmode.height() - pHeight.get(0)) / 2
			);
			
			// WIP: Set window icon
			// TODO: load the icon image
			// TODO: add it to the buffer
			// Buffer icon = new Buffer();
			// glfwSetWindowIcon(window, icon);
			
		} // the stack frame is popped automatically

		// Make the OpenGL context current
		glfwMakeContextCurrent(window);
		// Enable v-sync
		glfwSwapInterval(1);

		// Make the window visible
		glfwShowWindow(window);
	}

	private void loop() {
		// This line is critical for LWJGL's interoperation with GLFW's
		// OpenGL context, or any context that is managed externally.
		// LWJGL detects the context that is current in the current thread,
		// creates the GLCapabilities instance and makes the OpenGL
		// bindings available for use.
		GL.createCapabilities();

		// Set the clear color
		glClearColor(1.0f, 0.0f, 0.0f, 0.0f);

		// Run the rendering loop until the user has attempted to close
		// the window or has pressed the ESCAPE key.
		while ( ! glfwWindowShouldClose(window) ) {
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // clear the framebuffer

			glfwSwapBuffers(window); // swap the color buffers

			// Poll for window events. The key callback above will only be
			// invoked during this call.
			glfwPollEvents();
		}
	}

	public static void main(String[] args) {
		new Main().run();
	}

}
EOT


echo -e "\e[32m[INFO]\e[0m Writing .lite_project.lua"
touch .lite_project.lua
cat << EOT > .lite_project.lua
local core = require "core"
local config = require "core.config"


-- Ignore
table.insert(config.ignore_files, "lib")
table.insert(config.ignore_files, "bin")
table.insert(config.ignore_files, ".tools")

table.insert(config.ignore_files, ".lite_project.lua")

table.insert(config.ignore_files, ".git")


-- Disable
config.plugins.lsp_java = false


-- LSP Server
local lsp = require "plugins.lsp"

local function find_jars(rel_path, substring)
  local results = {}
  local base = system.absolute_path(rel_path)
  local function scan(dir)
    local entries = system.list_dir(dir)
    if not entries then return end
    for _, entry in ipairs(entries) do
      local abs = dir .. "/" .. entry
      local info = system.get_file_info(abs)
      if info and info.type == "dir" then
        scan(abs)
      elseif entry:match("%.jar$") then
        -- If a filter is provided, only include matching jars
        if not substring or entry:find(substring, 1, true) then
          table.insert(results, abs)
        end
      end
    end
  end
  scan(base)
  return results
end

local function append_to(target, source)
  for _, v in ipairs(source) do
    table.insert(target, v)
  end
end

local function find_folders(root_dir)
  local base = system.absolute_path(root_dir .. "/")
  local results = {}
  local entries = system.list_dir(base)
  if not entries then return results end
  for _, entry in ipairs(entries) do
    local abs = base .. "/" .. entry
    local info = system.get_file_info(abs)
    if info and info.type == "dir" then
      table.insert(results, abs)
    end
  end
  return results
end


local libs = {}
local sources = {}

-- This line needs to be wrapped inside a coroutine and launched in the background
-- append_to(libs, find_jars("/usr/lib/jvm/java-21-openjdk", ""))
-- append_to(libs, find_jars("./lib", ""))

---# Java - java-language-server
--- __Status__: Works
--- __Site__: https://github.com/georgewfraser/java-language-server
--- __Installation__: https://aur.archlinux.org/java-language-server.git
lsp.add_server {
  name = "java-language-server",
  language = "Java",
  file_patterns = { "%.java$" },
  command = { "java-language-server" },
  verbose = false,
  root_dir = system.absolute_path(".") .. "/",
  -- WIP: fix go-to-definition
  init_options = {
    extendedClientCapabilities = {
      classFileContentsSupport = true
    }
  },
  settings = {
    java = {
      sourcePath = find_folders("./src"),
      classPath = find_jars("./lib", ""),
      docPath = find_jars("./lib", "sources")
    }
  }
}
EOT


echo -e "\e[32m[INFO]\e[0m Downloading $LWJGL_FILE..."
wget "$LWJGL_URL"


echo -e "\e[32m[INFO]\e[0m Unzipping $LWJGL_FILE..."
unzip "$LWJGL_FILE".zip -d "lib/$LWJGL_FILE/"


echo -e "\e[32m[INFO]\e[0m Removing $LWJGL_FILE archive..."
rm -v "$LWJGL_FILE".zip


echo -e "\e[32m[INFO]\e[0m Downloading UMLDoclet..."
if [[ ! -f .tools ]]; then
  mkdir -v .tools
fi
wget "$UMLDOCLET_URL" --directory-prefix .tools
