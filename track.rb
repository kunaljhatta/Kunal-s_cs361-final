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