class BuoyDatum < ActiveRecord::Base
  attr_accessible :date, :buoy_id, :swell_direction, :swell_period, :water_temp, :wave_height, :wind_direction

  @@years = []

  def self.add_links(links_list, link)
    links_list << link
  end

  def self.create_date(history)
    date = history[0..2].join("-")
    time = history[3..4].join(":")
    date_and_time = "#{date} #{time}"
    history << date_and_time.to_datetime
  end

  def self.to_feet(height)
    height.to_f * 3.28084
  end

  def self.to_farenheit(temp)
    temp.to_f * 1.8 + 32
  end

  def self.create_from_file(link, buoy_id)
    history_page = Nokogiri::HTML(open("#{link}"))
    buoy_info = history_page.to_s.split("\n")
    buoy_info.pop
    buoy_info.shift
    buoy_info.each do |line|
      history_info = line.split(" ")
      if history_info[3]
        if history_info[3].to_i >= 5 && history_info[3].to_i <= 22
          create_date(history_info)
          create!(
            :date => history_info.last,
            :buoy_id => buoy_id,
            :swell_direction => history_info[11],
            :wave_height =>  BuoyDatum.to_feet(history_info[8]),
            :swell_period => history_info[10],
            :water_temp => BuoyDatum.to_farenheit(history_info[14]))
        end
      end
    end
  end

  def self.grab_year_info(buoys)
    buoys.each do |buoy|
      buoy_page = Nokogiri::HTML(open("#{buoy.url}"))
      year_line = buoy_page.css('a').select{ |link| link.text.match(/\A20/) }
      year_line.each do |link|
        @@years << link.text
        @@years.each do |year|
          buoy_file = "http://www.ndbc.noaa.gov/view_text_file.php?filename=#{buoy.name}h#{year}.txt.gz&dir=data/historical/stdmet/"
          create_from_file(buoy_file, buoy.id)
        end
      end
    end
  end

  def self.create_from_nbdc
    index_url = "http://www.ndbc.noaa.gov"
    buoys = Buoy.all
    grab_year_info(buoys)
  end


end
