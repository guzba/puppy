version     = "1.0.3"
author      = "Andre von Houck"
description = "Puppy fetches HTML pages for Nim."
license     = "MIT"

srcDir = "src"

requires "nim >= 1.4.4"
requires "urlly >= 0.2.0"
requires "libcurl >= 1.0.0"
requires "zippy >= 0.5.3"

when defined(windows):
  requires "winim >= 3.6.0"
