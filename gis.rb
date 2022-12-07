#!/usr/bin/env ruby

class Track

  def initialize(segments, name=nil)
    @name = name
    @segments = segments
  end

  def get_track_json()
    json_string = '{"type": "Feature", '

    if @name != nil
      json_string += '"properties": {"title": "' + @name + '"},'
    end

    json_string += '"geometry": {"type": "MultiLineString","coordinates": ['

    @segments.each_with_index do |segment, index|
      if index > 0
        json_string += ","
      end

      json_string += '['
      track_segment_json = ''
      segment.coordinates.each do |coordinate|

        if track_segment_json != ''
          track_segment_json += ','
        end
        # Add the coordinate
        track_segment_json += '['
        track_segment_json += "#{coordinate.lon},#{coordinate.lat}"
        if coordinate.ele != nil
          track_segment_json += ",#{coordinate.ele}"
        end
        track_segment_json += ']'
      end
      json_string+=track_segment_json
      json_string+=']'
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

  attr_reader :lat, :lon, :ele, :name, :type

  def initialize(lon, lat, ele=nil, name=nil, type=nil)
    @lat = lat
    @lon = lon
    @ele = ele
    @name = name
    @type = type
  end

  def get_waypoint_json(indent=0)
    json_string = '{"type": "Feature",'
    json_string += '"geometry": {"type": "Point","coordinates": '
    json_string += "[#{@lon},#{@lat}"
    if ele != nil
      json_string += ",#{@ele}"
    end
    json_string += ']},'
    if name != nil or type != nil
      json_string += '"properties": {'
      if name != nil
        json_string += '"title": "' + @name + '"'
      end
      if type != nil 
        if name != nil
          json_string += ','
        end
        json_string += '"icon": "' + @type + '"'  # type is the icon
      end
      json_string += '}'
    end
    json_string += "}"
    return json_string
  end
end

class World

  def initialize(name, things)
    @name = name
    @features = things
  end

  def add_feature(f)
    @features.append(t)
  end

  def to_geojson(indent=0)
    segment = '{"type": "FeatureCollection","features": ['
    @features.each_with_index do |feature,index|
      if index != 0
        segment +=","
      end
        if feature.class == Track
          segment += feature.get_track_json
        elsif feature.class == Waypoint
          segment += feature.get_waypoint_json
      end
    end
    segment + "]}"
  end
end

def main()
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")

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

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")
  track_segment_one = TrackSegment.new(ts1)
  track_segment_two = TrackSegment.new(ts2)
  track_segment_three = TrackSegment.new(ts3)

  t = Track.new([track_segment_one, track_segment_two], "track 1")
  t2 = Track.new([track_segment_three], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()
end

if File.identical?(__FILE__, $0)
  main()
end

