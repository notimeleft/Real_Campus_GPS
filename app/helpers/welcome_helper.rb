require './lib/map.rb'

module WelcomeHelper
	def self.nearest_building_id(lag_lng)
		lag_lng[0] = lag_lng[0].to_f
		lag_lng[1] = lag_lng[1].to_f

		tempMinDist = Float::INFINITY
		minID = 0
		Building.all.pluck(:id).each do |b_id|
			coord = [Node.find(b_id).latitude, Node.find(b_id).longitude]
			dist = self.geo_distance(lag_lng, coord)
			if dist < tempMinDist
				tempMinDist = dist
				minID = b_id
			end
		end
		return minID
	end

	def self.geo_distance(loc1, loc2)
  		rad_per_deg = Math::PI/180  # PI / 180
  		rkm = 6371                  # Earth radius in kilometers
  		rm = rkm * 1000             # Radius in meters

  		dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  		dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  		lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  		lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  		a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  		c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  		rm * c # Delta in meters
	end

	def self.find_route(start_id, end_id)
		result = []
		map = CampusMap.new()
		adjlist = Path.pluck(:start, :end, :distance)
		map.load_map(adjlist)
		paths = map.solve(start_id, end_id)
		strs = map.solve_text(start_id, end_id)
		paths.each do |id|
			node = Node.find(id)
			result.push([node.latitude, node.longitude])
		end
		return result, strs
	end
end
