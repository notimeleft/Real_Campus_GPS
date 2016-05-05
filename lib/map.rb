require './lib/heap'

class CampusMap

	def initialize
		@graph = DirectedGraph.new
	end

	def load_map(pathArr)
		pathArr.each do |_start, _end, _distance|
			@graph.add_edge(_start, _end, _distance)
		end
	end

	def solve_text(start_id, end_id)
		ret = ""
		paths, distance = @graph.shortest_path(start_id, end_id)
		return false if paths == false
		paths.each do |p_id, s_id, distance|
			text = (Path.where(start: p_id, end: s_id)[0]).description
			if text != nil
				ret = ret + text.to_s + "\n"
			end
		end
		return ret
	end

	def solve(start_id, end_id)
		ret = []
		paths, distance = @graph.shortest_path(start_id, end_id)
		return false, -1 if paths == false
		paths.each do |p_id, s_id, distance|
			ret.push(p_id)
		end
		ret.push((paths.last)[1])
		return ret, distance
	end

end

class DirectedGraph

	def initialize
		@nodes = {}
	end

	def add_node(node)
		@nodes[node.id] = node
	end

	def add_edge(predecessor_id, successor_id, weight)
		add_node(Vertice.new(predecessor_id)) if not @nodes.has_key?(predecessor_id)
		add_node(Vertice.new(successor_id)) if not @nodes.has_key?(successor_id)
		@nodes[predecessor_id].add_edge(@nodes[successor_id], weight)
	end

	def shortest_path(start_id, end_id)
		distance = {}
		visited = {}
		predecessor = {}
		@nodes.keys.each do |node_id|
			distance[node_id] = Float::INFINITY
		end
		minheap = MinHeap.new
		minheap.push([0, start_id])
		distance[start_id] = 0.0
		while not minheap.is_empty? do
			curr_node = @nodes[(minheap.pop)[1]]
			break if curr_node.id == end_id
			next if visited.has_key?(curr_node.id)
			visited[curr_node.id] = true
			curr_node.iter.each do |next_node, weight|
				if distance[next_node.id] > distance[curr_node.id] + weight
					distance[next_node.id] = distance[curr_node.id] + weight
					minheap.push([distance[next_node.id], next_node.id])
					predecessor[next_node.id] = [curr_node.id, weight]
				end
			end
		end
		return false if curr_node.id != end_id
		paths = []
		ptr = end_id
		while ptr != start_id do
			paths.unshift [predecessor[ptr][0], ptr, predecessor[ptr][1]]
			ptr = predecessor[ptr][0]
		end
		return paths, distance[end_id]
	end

end

class Vertice

	attr_reader :id

	def initialize(id)
		@id = id
		@successors = []
	end

	def add_edge(successor, weight)
		@successors << [successor, weight]
	end

	def iter
		return @successors
	end

end
