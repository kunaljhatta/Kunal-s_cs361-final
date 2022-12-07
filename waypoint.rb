class Waypoint

  attr_accessor :lat, :lon, :ele, :name, :point, :printer

  def initialize(lon, lat, ele=300000, name= '', point= '', printer)
    @lat = lat
    @lon = lon
    @ele = ele
    @name = name
    @point = point
    @printer = printer
  end

  def to_json
    printer.to_json(self)
  end
  
end

class WaypointString
  def to_json(point)
    json_string = '{"type": "Feature","geometry": {"type": "Point","coordinates": '
    json_string += "[#{point.lon},#{point.lat}"

    if point.ele != 300000
      json_string += ",#{point.ele}"
    end

    json_string += ']},'

    if !point.name.empty? or !point.point.empty?
      json_string += '"properties": {'

      if !point.name.empty?
        json_string += '"title": "' + point.name + '"'
      end

      if !point.point.empty?

        if !point.name.empty?
          json_string += ','
        end

        json_string += '"icon": "' + point.point + '"' 
      end
      json_string += '}'
    end
    json_string += "}"
  end
end
