#! /usr/bin/env  ruby

require 'nokogiri'
require 'open-uri'

# Fetch and parse the HTML
doc = Nokogiri::HTML(open('https://www.muis.gov.sg/mosque/Our-Mosques/Mosque-Directory'))

puts "test"
doc.css('table tbody td a').each do |tag|
  puts tag['href']
end
