require_relative 'gis.rb'
require 'json'
require 'test/unit'

class TestGis < Test::Unit::TestCase

  def test_waypoints
    waypoint_json = WaypointString.new
    w = Waypoint.new(-121.5, 45.5, 30, "home", "flag", waypoint_json)
    expected = JSON.parse('{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}}')
    result = JSON.parse(w.to_json)
    assert_equal(result, expected)

    w = Waypoint.new(-121.5, 45.5, 300000, '', "flag", waypoint_json)
    expected = JSON.parse('{"type": "Feature","properties": {"icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5]}}')
    result = JSON.parse(w.to_json)
    assert_equal(result, expected)

    w = Waypoint.new(-121.5, 45.5, 300000, "store", '', waypoint_json)
    expected = JSON.parse('{"type": "Feature","properties": {"title": "store"},"geometry": {"type": "Point","coordinates": [-121.5,45.5]}}')
    result = JSON.parse(w.to_json)
    assert_equal(result, expected)
  end

  def test_tracks
    ts1 = [
      Coordinate.new(-122, 45),
      Coordinate.new(-122, 46),
      Coordinate.new(-121, 46),
    ]

    ts2 = [ Coordinate.new(-121, 45), Coordinate.new(-121, 46), ]

    ts3 = [
      Coordinate.new(-121, 45.5),
      Coordinate.new(-122, 45.5),
    ]
    
    track_json = TrackString.new
    track_segment_one = TrackSegment.new(ts1)
    track_segment_two = TrackSegment.new(ts2)
    track_segment_three = TrackSegment.new(ts3)

    t = Track.new([track_segment_one, track_segment_two], "track 1", track_json)
    expected = JSON.parse('{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}}')
    result = JSON.parse(t.to_json)
    assert_equal(expected, result)

    t = Track.new([track_segment_three], "track 2", track_json)
    expected = JSON.parse('{"type": "Feature", "properties": {"title": "track 2"},"geometry": {"type": "MultiLineString","coordinates": [[[-121,45.5],[-122,45.5]]]}}')
    result = JSON.parse(t.to_json)
    assert_equal(expected, result)
  end

  def test_world
    waypoint_json = WaypointString.new
    w = Waypoint.new(-121.5, 45.5, 30, "home", "flag", waypoint_json)
    w2 = Waypoint.new(-121.5, 45.6, 300000, "store", "dot", waypoint_json)
    ts1 = [
      Coordinate.new(-122, 45),
      Coordinate.new(-122, 46),
      Coordinate.new(-121, 46),
    ]

    ts2 = [ Coordinate.new(-121, 45), Coordinate.new(-121, 46), ]

    ts3 = [
      Coordinate.new(-121, 45.5),
      Coordinate.new(-122, 45.5),
    ]
    
    track_json = TrackString.new
    track_segment_one= TrackSegment.new(ts1)
    track_segment_two = TrackSegment.new(ts2)
    track_segment_three = TrackSegment.new(ts3)

    t = Track.new([track_segment_one, track_segment_two], "track 1", track_json)
    t2 = Track.new([track_segment_three], "track 2", track_json)

    w = World.new("My Data", [w, w2, t, t2])

    expected = JSON.parse('{"type": "FeatureCollection","features": [{"type": "Feature","properties": {"title": "home","icon": "flag"},"geometry": {"type": "Point","coordinates": [-121.5,45.5,30]}},{"type": "Feature","properties": {"title": "store","icon": "dot"},"geometry": {"type": "Point","coordinates": [-121.5,45.6]}},{"type": "Feature", "properties": {"title": "track 1"},"geometry": {"type": "MultiLineString","coordinates": [[[-122,45],[-122,46],[-121,46]],[[-121,45],[-121,46]]]}},{"type": "Feature", "properties": {"title": "track 2"},"geometry": {"type": "MultiLineString","coordinates": [[[-121,45.5],[-122,45.5]]]}}]}')
    result = JSON.parse(w.to_geojson)
    assert_equal(expected, result)
  end

end
