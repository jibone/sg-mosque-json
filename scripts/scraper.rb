#! /usr/bin/env ruby

# Data scraped with this script are not complete. Need to manually update the json by hand.

require 'nokogiri'
require 'open-uri'
require 'json'

Mosque = Struct.new(
  :name,
  :address,
  :phone,
  :fax,
  :email,
  :website,
)

mosque_list = []

def get_mosque_details(url, mosque)
  path = 'https://www.muis.gov.sg' + url
  puts "> Fetching: #{path}"
  doc = Nokogiri::HTML(open(path))

  details = {
    address: '.location',
    phone: '.phone',
    fax: '.faq',
    email: '.email',
    website: '.website',
  }

  details.each do |key, value|
    unless doc.at_css(value).nil?
      mosque[key] = doc.at_css(value).content.strip.gsub(/\s+/, " ")
    end
  end

  mosque
end

def get_mosque_name(tag)
  puts "> Retriving details: #{tag.content}"
  mosque = Mosque.new(tag.content)
  get_mosque_details(tag['href'], mosque)
end

# Fetch and parse the HTML
doc = Nokogiri::HTML(open('https://www.muis.gov.sg/mosque/Our-Mosques/Mosque-Directory'))

puts 'Start scraping'
count = 0
doc.css('table tbody td a').each do |tag|
  #break if count > 2
  mosque_list << get_mosque_name(tag)
  count = count + 1
end

puts 'Done scraping'

hash_prepare = {
  'mosques' => [],
  'meta' => {
    'last_updated' => ''
  }
}

mosque_list.each do |mq|
  hash_prepare['mosques'] << {
    'name' => mq.name,
    'address' => mq.address,
    'location' => {
      'latitude' => 0.0,
      'longitude' => 0.0
    },
    'bus' => [],
    'mrt' => [],
    'phone' => mq.phone,
    'fax' => mq.fax,
    'email' => mq.email,
    'website' => mq.website,
    'type' => ''
  }
end

puts "Writing to file"
File.open("temp.json","w") do |f|
  f.write(JSON.pretty_generate(hash_prepare))
end

