require "Set"
# Zhengyang Zhou
# To see whether path exists between two points using Breadth first search
# Attribute, pass the plane and the graph of maze first
class MazeSolver
  attr_accessor :plane,:graph

  def initialize(plane,graph)
    @plane = plane
    @graph = graph
  end

  # Use breadth first search to seek a Path
  # Use set named 'visted' to mark the visted cell
  # Use queue named 'que' to do the search
  # In particular, each element in the queue has three attributes: path, trans, cur
  # path is the path between two points based on cell coordinate.
  # trans is the path between two points based on cell-wall coordinate, which is to help draw the tracing graph
  # Cur is the current point based on cell coordinate
  # For example, Suppose I have a maze in size 1 by 2 like the following
  #  * * * * *
  #  * X   Y *
  #  * * * * *
  #  When we reach Y
  #  The path on cell coordinate from X to Y will be [[0,0],[1,0]]
  #  The trans on cell-wall coordinate from X to Y will be [[1,1],[1,2],[1,3]] as we have to do transformation in correct_matrix
  #  The cur would be [1,0]
  #  When it reaches the end point, return its path and trans. If not found or invalid points, return two empty array respectively
  def solve(begX, begY, endX, endY)
    return [],[] if(validate_two_end(translate(begX),translate(begY), translate(endX),translate(endY)) == false)
    start = [begX,begY]
    start_tran = [translate(begY),translate(begX)]
    goal = [endX, endY]
    que = Queue.new; visited = Set.new
    que.push([[start],[start_tran],start])
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
    #Try to make a step right to the current cell. If it is 1, then it is a wall. 0 will be a hole.
    sub_directional_search(plane,que,cur,tran,path,1,0)
    #Try to make a step left to the current cell. If it is 1, then it is a wall. 0 will be a hole.
    sub_directional_search(plane,que,cur,tran,path,-1,0)
    #Try to make a step up to the current cell. If it is 1, then it is a wall. 0 will be a hole.
    sub_directional_search(plane,que,cur,tran,path,0,1)
    #Try to make a step down to the current cell. If it is 1, then it is a wall. 0 will be a hole.
    sub_directional_search(plane,que,cur,tran,path,0,-1)
  end

  def sub_directional_search(plane,que,cur,tran,path,change_x,change_y)
    if(plane[translate(cur[1]) + change_x][translate(cur[0])+change_y] == 0)
      new_tran = Array.new(tran).push([translate(cur[1]) + change_x,translate(cur[0])+ change_y]).push([translate(cur[1]+change_x),translate(cur[0]+change_y)])
      que.enq([Array.new(path).push([cur[0]+change_y,cur[1]+change_x]),new_tran,[cur[0]+change_y,cur[1]+change_x]])
    end
  end

  # Trace the solution and draw the graph
  def trace(begX, begY, endX, endY)
    path,solution = solve(begX, begY, endX, endY)
    if(solution.length != 0)
      solution.each{|x| self.graph[x[0]][x[1]] = '@'}
      puts graph.map { |x| x.join(' ') }
    else
      puts "There are no way from #{[begX,begY]} to #{[endX,endY]}"
    end
  end

  #Check whether two input points are not out of bound
  def validate_two_end(begX, begY, endX, endY)
    puts "Outbound input point(s)" if validation(begX, begY) && validation(endX,endY) == false
    return validation(begX, begY) && validation(endX,endY)
  end

  #Check whether a point is out of bound
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

  # Translate the coordinate based on cell to that based on cell and wall
  def translate(x)
    return 2 * x + 1
  end

end
