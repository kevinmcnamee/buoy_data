class Buoy < ActiveRecord::Base
  require 'nokogiri'
  require 'open-uri'

  attr_accessible :coordinates, :name, :buoy_type, :url, :latitude, :longitude
  acts_as_gmappable

  has_many :buoy_datum

  # geocoded_by :full_street_address
  # after_validation :geocode

  def gmaps4rails_address
    "#{self.latitude}, #{self.longitude}"
  end

  def gmaps4rails_infowindow
    "<strong>Buoy #{self.name}</strong></br>
    <a href=\"http://www.ndbc.noaa.gov/station_page.php?station=#{self.name}\" target=\"blank\">Visit on nbdc</a>"
  end

  @@regions = []


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
  
  private
  def self.add_links(links_list, link)
    links_list << link
  end

  #I want to refactor to move parsing logic into BuoyParse model
  # def self.new_from_parser(raw_data)
  #   @buoy_lat =BuoyParser.new(raw_data)
  #   self.new.tap do |b|
  #     b.lat = @buoy_parser.lat
  #   end
  # end

  def self.coordinates(url, link) 
    page = Nokogiri::HTML(open("#{url}#{link}"))
    coords = page.css("td p b").select { |link| link.text.match(/" W\)/)}
    coord_text = coords.first.text
    coordinates = coord_text.split("(").first
    lat_long = coordinates.split("N")
    longitude = lat_long[1].split("W")
    latitude = lat_long[0]
    latitude_longitude = [latitude.to_f, longitude[0].to_f]
  end

  def self.build_regions(url)
    @@regions.each do |region|
      region_maps = Nokogiri::HTML(open("#{url}#{region}"))
      region_maps.css("map area").map do |link|
        if link["alt"].match(/\A4/)
          lat_long = coordinates(url,link["href"])
          create!(
            # :coordinates => coordinates(url,link["href"]),
            :name => link["alt"],
            :url => "#{url}#{link["href"]}",
            :latitude => lat_long.first,
            :longitude => lat_long.last*(-1)
            )
        end
      end
    end
  end  

end

