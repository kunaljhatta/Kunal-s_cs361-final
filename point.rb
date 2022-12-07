class Point

  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end
end

class Coordinate < Point

  def initialize(lon, lat, ele=nil)
    super
  end

  def latitude
    @lat
  end

  def longitude
    @lon
  end

  def elevation
    @ele
  end

  def to_json
  end
end