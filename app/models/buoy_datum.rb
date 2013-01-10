class BuoyDatum < ActiveRecord::Base
  attr_accessible :date, :quality, :buoy_id, :swell_direction, :swell_period, :water_temp, :wave_height, :wind_direction
  belongs_to :buoy

  self.per_page = 10

  scope :within_range, lambda { |from, to| where("date >= ? AND date <= ?", from, to) }

  def self.create_from_nbdc
    index_url = "http://www.ndbc.noaa.gov"
    buoys = Buoy.all
    buoys.each do |buoy|
      grab_year_info(buoy)
    end
  end


  def year
    date.to_datetime.strftime("%Y")
  end

  def month
    date.to_datetime.strftime("%m")
  end

  def day
    date.to_datetime.strftime("%d")
  end

  def hour
    date.to_datetime.strftime("%H")
  end

  private

  def self.grab_year_info(buoy)
    years =[]
    buoy_page = Nokogiri::HTML(open("#{buoy.url}"))
    year_line = buoy_page.css('a').select{ |link| link.text.match(/\A20/) }
    year_line.each do |link|
      years << link.text unless years.include?(link.text) || link.text.to_i < 2005
    end
    years.each do |year|
      buoy_file = "http://www.ndbc.noaa.gov/view_text_file.php?filename=#{buoy.name}h#{year}.txt.gz&dir=data/historical/stdmet/"
      create_from_file(buoy_file, buoy.id)
    end
  end

  def self.create_from_file(link, buoy_id)
    open(link).readlines.each do |line|
      if line.match(/^20/)
        year, month, day, hour, minute, wind_direction, wind_speed, gust, wave_height,
        dominant_period, swell_period, swell_direction, pressure, air_temp, water_temp, dew,
        visibility, tide = line.chomp.split(' ')
        if hour.to_i >= 5 && hour.to_i <= 22
          create!(
            :date => ("#{day}-#{month}-#{year} #{hour}:#{minute}").to_datetime,
            :buoy_id => buoy_id,
            :swell_direction => swell_direction,
            :wave_height => BuoyDatum.to_feet(wave_height),
            :swell_period => swell_period,
            :water_temp => BuoyDatum.to_farenheit(water_temp),
            :quality => BuoyDatum.quality(BuoyDatum.to_feet(wave_height), swell_period.to_f))
        end
      end
    end
  end

  def self.quality(wave_height, swell_period)
    case 
    when wave_height > 6 && swell_period > 12
      6
    when wave_height > 6 && swell_period < 12
      5
    when wave_height > 4 && swell_period > 10
      4
    when wave_height > 4 && swell_period < 10
      3
    when wave_height > 2.5 && swell_period > 12
      2
    when wave_height > 2.5 && swell_period > 7
      1   
    else
      0
    end
  end

  def self.create_date(history)
    date = history[0..2].join("-")
    time = history[3..4].join(":")
    date_and_time = "#{date} #{time}"
    history << date_and_time.to_datetime
  end  

  def self.add_links(links_list, link)
    links_list << link
  end

  def self.to_feet(height)
    (height.to_f * 3.28084).round(1)
  end

  def self.to_farenheit(temp)
    (temp.to_f * 1.8 + 32).round(1)
  end

end
