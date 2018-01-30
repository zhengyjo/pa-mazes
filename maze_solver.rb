require "Set"

class MazeSolver
  attr_accessor :plane,:graph

  def initialize(plane,graph)
    @plane = plane
    @graph = graph
  end

  def solve(begX, begY, endX, endY)
    return [],[] if(validate_two_end(translate(begX),translate(begY), translate(endX),translate(endY)) == false)
    start = [begX,begY]
    start_tran = [translate(begX),translate(begY)]
    goal = [endX, endY]
    que = Queue.new
    que.push([[start],[start_tran],start])
    visited = Set.new
    while(!que.empty?)
      path,tran,cur = que.deq
      return path,tran if(cur == goal)
      next if visited.include?(cur)
      visited.add(cur)
      breadth_first_search(plane,que,cur,tran,path)
    end
    return [],[]
  end

  def breadth_first_search(plane,que,cur,tran,path)
    if(plane[translate(cur[1]) + 1][translate(cur[0])] == 0)
      new_tran = Array.new(tran).push([translate(cur[1]) + 1,translate(cur[0])]).push([translate(cur[1]+1),translate(cur[0])])
      que.enq([Array.new(path).push([cur[0],cur[1]+1]),new_tran,[cur[0],cur[1]+1]])
    end
    if(plane[translate(cur[1]) - 1][translate(cur[0])] == 0)
      new_tran = Array.new(tran).push([translate(cur[1]) - 1,translate(cur[0])]).push([translate(cur[1]-1),translate(cur[0])])
      que.enq([Array.new(path).push([cur[0],cur[1]-1]),new_tran,[cur[0],cur[1]-1]])
    end
    if(plane[translate(cur[1])][translate(cur[0]) + 1] == 0)
      new_tran = Array.new(tran).push([translate(cur[1]),translate(cur[0])+1]).push([translate(cur[1]),translate(cur[0]+1)])
      que.enq([Array.new(path).push([cur[0] + 1,cur[1]]),new_tran,[cur[0] + 1,cur[1]]])
    end
    if(plane[translate(cur[1])][translate(cur[0]) - 1] == 0)
      new_tran = Array.new(tran).push([translate(cur[1]),translate(cur[0])-1]).push([translate(cur[1]),translate(cur[0]-1)])
      que.enq([Array.new(path).push([cur[0] - 1,cur[1]]),new_tran,[cur[0] - 1,cur[1]]])
    end
  end

  def trace(begX, begY, endX, endY)
    path,solution = solve(begX, begY, endX, endY)
    if(solution.length != 0)
      solution.each{|x| self.graph[x[0]][x[1]] = '@'}
      puts graph.map { |x| x.join(' ') }
    else
      puts "There are no way from #{[begX,begY]} to #{[endX,endY]}"
    end
  end

  def validate_two_end(begX, begY, endX, endY)
    puts "Outbound input point(s)" if validation(begX, begY) && validation(endX,endY) == false
    return validation(begX, begY) && validation(endX,endY)
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
