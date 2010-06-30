# FreebaseQuery
begin
  require 'open-uri'
  require 'hpricot'
  require 'ken'
  require 'cgi'
  require 'freebase/resource'
  require 'freebase/genre'
  require 'freebase/artist'
  require 'wikipedia/page'
rescue LoadError => e
  puts "Some gems not found. #{e}"
end