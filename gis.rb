#!/usr/bin/env ruby

class Track

  attr_accessor :name, :segments, :printer
  
  def initialize(segments, name='', printer)
    @name = name
    @segments = segments
    @printer = printer
  end
  
  def to_json
    printer.to_json(self)
  end
end

class TrackString

  def to_json(string)
    json_string = '{"type": "Feature", '

    if string.name != ''
      json_string += '"properties": {"title": "' + string.name + '"},'
    end

    json_string += '"geometry": {"type": "MultiLineString","coordinates": ['

    string.segments.each_with_index do |segment, index|
      if index > 0
        json_string += ","
      end
      
      json_string += '['

      track_segment_json = ''

      segment.coordinates.each do |coordinate|
        if track_segment_json != ''
          track_segment_json += ','
        end

        track_segment_json += "[#{coordinate.lon},#{coordinate.lat}"

        if coordinate.ele != nil
          track_segment_json += ",#{coordinate.ele}"
        end

        track_segment_json += ']'
      end
      json_string += track_segment_json
      json_string += ']'
    end
    json_string + ']}}'
  end
end

class TrackSegment

  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end
end

class Point

  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele=nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end
end

class Coordinate < Point

  def initialize(lon, lat, ele = nil)
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

  def json

  end
end

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

class World

  def initialize(name, features)
    @name = name
    @features = features
  end

  def add_feature(feature)
    @features.append(type)
  end

  def to_geojson(indent=0)
    segment = '{"type": "FeatureCollection","features": ['
    @features.each_with_index do |feature,index|
      if index != 0
        segment +=","
      end
      segment += feature.to_json
    end
    segment + "]}"
  end
end

def main()
  waypoint_json = WaypointString.new
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag", waypoint_json )
  w2 = Waypoint.new(-121.5, 45.6, 300000, "store", "dot", waypoint_json)

  ts1 = [
  Coordinate.new(-122, 45),
  Coordinate.new(-122, 46),
  Coordinate.new(-121, 46),
  ]

  ts2 = [ 
    Coordinate.new(-121, 45), 
    Coordinate.new(-121, 46), 
  ]

  ts3 = [
    Coordinate.new(-121, 45.5),
    Coordinate.new(-122, 45.5),
  ]

  track_json = TrackString.new
  track_segment_one = TrackSegment.new(ts1)
  track_segment_two = TrackSegment.new(ts2)
  track_segment_three = TrackSegment.new(ts3)

  t = Track.new([track_segment_one, track_segment_two], "track 1", track_json)
  t2 = Track.new([track_segment_three], "track 2", track_json)

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()
end

if File.identical?(__FILE__, $0)
  main()
end

