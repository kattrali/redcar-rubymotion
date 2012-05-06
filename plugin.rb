Plugin.define do
  name    "Cocoa"
  version "0.2"
  file    "lib", "Cocoa"
  object  "Redcar::Cocoa"
  dependencies "HTML View", ">0",
               "runnables", ">0",
               "syntax_check", ">0"
end
