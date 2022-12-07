#!/usr/bin/env ruby

class Track

  def initialize(segments, name=nil)
    @name = name
    segment_objects = []
    segments.each do |s|
      segment_objects.append(TrackSegment.new(s))
    end
    # set segments to segment_objects
    @segments = segment_objects
  end

  def get_track_json()
    json_string = '{"type": "Feature", '
    if @name != nil
      json_string+= '"properties": {'
      json_string += '"title": "' + @name + '"'
      json_string += '},'
    end
    json_string += '"geometry": {"type": "MultiLineString","coordinates": ['
    @segments.each_with_index do |segment, index|
      if index > 0
        json_string += ","
      end
      json_string += '['
      track_segment_json = ''
      segment.coordinates.each do |c|
        if track_segment_json != ''
          track_segment_json += ','
        end
        # Add the coordinate
        track_segment_json += '['
        track_segment_json += "#{c.lon},#{c.lat}"
        if c.ele != nil
          track_segment_json += ",#{c.ele}"
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
    s = '{"type": "FeatureCollection","features": ['
    @features.each_with_index do |f,i|
      if i != 0
        s +=","
      end
        if f.class == Track
            s += f.get_track_json
        elsif f.class == Waypoint
            s += f.get_waypoint_json
      end
    end
    s + "]}"
  end
end

def main()
  w = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  w2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")
  ts1 = [
  Point.new(-122, 45),
  Point.new(-122, 46),
  Point.new(-121, 46),
  ]

  ts2 = [ Point.new(-121, 45), Point.new(-121, 46), ]

  ts3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5),
  ]

  t = Track.new([ts1, ts2], "track 1")
  t2 = Track.new([ts3], "track 2")

  world = World.new("My Data", [w, w2, t, t2])

  puts world.to_geojson()
end

if File.identical?(__FILE__, $0)
  main()
end

