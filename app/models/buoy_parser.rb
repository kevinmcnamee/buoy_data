class BouyParser
  def initialize(raw_data)
    @raw_data = daw_data
  end

  def lat
    lat_long = coordinates.split("N")
    longitude = lat_long[1].split("W")
    latitude = lat_long[0]
    latitude_longitude = [latitude.to_f, longitude[0].to_f]
  end


end