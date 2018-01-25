require "Set"

class MazeSolver
  attr_accessor :plane,:graph

  def initialize(plane,graph)
    @plane = plane
    @graph = graph
  end

  def solve(begX, begY, endX, endY)
    start = [begX,begY]
    goal = [endX, endY]
    que = Queue.new
    que.push([[start],start])
    visited = Set.new
    while(!que.empty?)
      path,cur = que.deq
      if(cur == goal)
        puts "#{path}"
        return path
      end
      if visited.include?(cur)
        next
      end
      visited.add(cur)
      if(plane[translate(cur[1]) + 1][translate(cur[0])] == 0)
        que.enq([Array.new(path).push([cur[0],cur[1]+1]),[cur[0],cur[1]+1]])
      end
      if(plane[translate(cur[1]) - 1][translate(cur[0])] == 0)
        que.enq([Array.new(path).push([cur[0],cur[1]-1]),[cur[0],cur[1]-1]])
      end
      if(plane[translate(cur[1])][translate(cur[0]) + 1] == 0)
        que.enq([Array.new(path).push([cur[0] + 1,cur[1]]),[cur[0] + 1,cur[1]]])
      end
      if(plane[translate(cur[1])][translate(cur[0]) - 1] == 0)
        que.enq([Array.new(path).push([cur[0] - 1,cur[1]]),[cur[0] - 1,cur[1]]])
      end
    end
    puts "There is no way"
    return []
  end

  def trace(begX, begY, endX, endY)
    solution = solve(begX, begY, endX, endY)
    #solution.each{|x| puts "#{self.graph.class}"}
    solution.each{|x| self.graph[translate(x[1])][translate(x[0])] = '@'}
    puts graph.map { |x| x.join(' ') }
  end

  def validation(x, y)
    if(x >= plane[0].length || x < 0)
      puts "invalid start or end point on across direction"
      return false
    end
    if(y >= plane.length || y < 0)
      puts "invalid start or end point on down direction"
      return false
    end
    return true
  end

  def translate(x)
    return 2 * x + 1
  end

end
