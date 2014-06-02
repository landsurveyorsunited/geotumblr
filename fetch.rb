#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'exifr'
require 'tumblr_client'
require 'chunky_png'

Tumblr.configure do |config|
  config.consumer_key = ENV['TUMBLR_API_KEY']
end

blog_name = ENV['TUMBLR_NAME']

client = Tumblr::Client.new

puts "start fetching"

points = []

offset = 0
postcount = 200
while offset < postcount do
  puts "fetching from offset #{offset}"
  posts = client.posts(blog_name, limit: 20, offset: offset)
  
  posts['posts'].each do |post|
    post['photos'].each do |photo|
      url = photo['original_size']['url']
      image = open(url)
      
      begin
        gps = EXIFR::JPEG.new(image).gps
        if gps && gps.longitude != 0.0 && gps.latitude != 0.0
          points << {
            type: 'Feature',
            properties: {
              caption: photo['caption'],
              imgsrc: url, 
              entryurl: post['post_url'],
              tags: post['tags'],
              source: post['blog_name']
            },
            geometry: {
              type: 'Point',
              coordinates: [gps.longitude, gps.latitude]
            }
          }        
        end
      rescue EXIFR::MalformedJPEG
        if (url.match(/\.png$/))
          puts "PNG?"
          # image.rewind
          # png = ChunkyPNG::Image.from_io(image)
          # puts png.metadata.inspect
        else
          puts "malformed JPEG: #{url}"
        end
      end
      image.close      
    end
  end
  
  
  postcount = posts['total_posts']
  offset += posts['posts'].length
end

geojson = {
  type: 'FeatureCollection',
  features: points
}

puts geojson.to_json

File.open("#{blog_name}.geojson", 'wb') do |f|
  f.write(geojson.to_json)
end
