class Buoy < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  attr_accessible :coordinates, :name, :buoy_type, :url

  @@regions = []

  def self.add_links(links_list, link)
    links_list << link
  end

  def get_coordinates(coordinates_list, coordinates)
    coordinates_list << coordinates
  end


  #this needs work to make sure we are getting the correct coordinates
  def self.coordinates(url, link) 
    page = Nokogiri::HTML(open("#{url}#{link}"))
    coords = page.css("td p b").select { |link| link.text.match(/" W\)/)}
  end

  def self.build_regions(url)
    @@regions.each do |region|
      region_maps = Nokogiri::HTML(open("#{url}#{region}"))
      region_maps.css("map area").map do |link|
        if link["alt"].match(/\A4/)
          create!(
            :coordinates => Buoy.coordinates(url,link["href"]),
            :name => link["alt"],
            :url => "#{url}#{link["href"]}")
        end
      end
    end
  end

  def self.create_from_nbdc
    index_url = "http://www.ndbc.noaa.gov"
    @@regions =["/maps/southeast_hist.shtml", "/maps/northeast_hist.shtml", "/maps/florida_hist.shtml" ]
    buoy_pages = []
    @@regions.each do |region|
      region_maps = Nokogiri::HTML(open("#{index_url}#{region}"))
      region_maps.css("map area").map do |link| 
        if link["href"].match(/\A\/maps/)
          add_links(@@regions, link["href"])
        elsif link["href"].match(/[^\.]+[shtml]\z/)
          add_links(@@regions, "/maps/#{link["href"]}")
        end
        if link["alt"].match(/\A4/)
          add_links(buoy_pages, link["href"])
        end
      end
    end
    build_regions(index_url)
  end

end

