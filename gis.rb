#!/usr/bin/env ruby

require_relative 'track'
require_relative 'point'
require_relative 'waypoint'
require_relative 'world'

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

