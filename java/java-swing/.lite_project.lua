local config = require "core.config"

config.ignore_files = {
  "^%.",
  "^bin$",
  "^lib$",
  "^Manifest.txt$",
  "^.-%.jar$"
}
