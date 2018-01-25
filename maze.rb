require './maze_solver.rb'

class Maze
  attr_accessor :plane,:graph,:valid
  attr_reader :across,:down,:length

  def initialize(across,down)
    @valid = true
    @across = across
    @down = down
    @length = (2 * (self.across) + 1) * (2 * (self.down) + 1)
    @plane = Array.new((2 * (self.down) + 1)){Array.new((2 * (self.across) + 1),0)}
  end

  def load(arg)
    if(first_validate_arg(arg))
      arg_arr = arg.split("")
      for i in 0..(self.length-1) do
        row = i / (2 * (self.across) + 1)
        col = i % (2 * (self.across) + 1)
        plane[row][col] = arg_arr[i].to_i
      end
      second_validate
      if(self.valid == true)
        draw_graph
      end
    end
  end

  def first_validate_arg(arg)
    if(arg.length != length)
      puts "The length of the string is not correct. Your input length is #{arg.length} but the length needs to be #{length}"
      self.valid = false
      return false
    else
      arg.split("").each do |i|
          if(i != '0' && i !='1')
            puts "The input argument contain(s) characters other than 0 and 1. Please correct!"
            self.valid = false
            return false
          end
      end
    end
    return true
  end

  def second_validate
    across_req_bound = Array.new((2 * (self.across) + 1),1)
    down_req_bound = Array.new((2 * (self.down) + 1),1)
    top_bound = self.plane[0]
    down_bound = self.plane[2 * (self.down)]
    left_bound = self.plane.map{|a| a[0]}
    right_bound = self.plane.map{|a| a[2 * (self.across)]}
    if(top_bound != across_req_bound || down_bound != across_req_bound ||left_bound != down_req_bound || right_bound != down_req_bound)
      puts "One of the boundaries is not closed"
      self.valid = false
    end
    cell_validate
  end

  def cell_validate
    height = 2 * self.down - 1
    width = 2 * self.across - 1
    for i in (1..height).step(2) do
      for j in (1..width).step(2) do
        wall_num = calculate_boundary_sum(i,j)
        if(wall_num == 4 || wall_num == 0)
          puts "[#{i},#{j}] is a dead cell or empty cell. Please enter another valid string"
          self.valid = false
        end
      end
    end
  end

  def calculate_boundary_sum(i,j)
    wall_num = 0
    self.plane[i-1][j-1..j+1].sum == 3? wall_num += 1: wall_num
    self.plane[i+1][j-1..j+1].sum == 3? wall_num += 1: wall_num
    self.plane[i-1..i+1].map{|a| a[j-1]}.sum == 3? wall_num += 1: wall_num
    self.plane[i-1..i+1].map{|a| a[j+1]}.sum == 3? wall_num += 1: wall_num
    return wall_num
  end

  def draw_graph
    @graph = Array.new((2 * (self.down) + 1)){Array.new((2 * (self.across) + 1),"")}
    for i in 0..(2 * (self.down)) do
      for j in 0..(2 * (self.across)) do
        plane[i][j] == 1? graph[i][j] = '*': graph[i][j] = ' '
      end
    end
  end

  def display
    puts graph.map { |x| x.join(' ') }
  end

  def solve(begX, begY, endX, endY)
      solver = MazeSolver.new(plane,graph)
      solver.solve(begX, begY, endX, endY)
  end

  def trace(begX, begY, endX, endY)
      solver = MazeSolver.new(plane,graph)
      solver.trace(begX, begY, endX, endY)
  end

end

#################Testing##############################
m = Maze.new(4,4)
m.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
#m.load("101101111")
#puts m.plane.map { |x| x.join(' ') }
m.trace(0,0,3,3)
# n = Array.new((2 * (m.across) + 1),'1')
# x = m.plane.map{|a| a[0]}
# puts x
