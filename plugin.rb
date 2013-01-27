Plugin.define do
  name    "Cocoa"
  version "0.9.1"
  file    "lib", "cocoa"
  object  "Redcar::Cocoa"
  dependencies "HTML View", ">0",
               "runnables", ">0",
               "syntax_check", ">0",
               "snippets", ">0"
end
