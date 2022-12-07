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
