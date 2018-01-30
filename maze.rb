require './maze_solver.rb'
require './maze_redesign.rb'

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
      draw_graph if(self.valid == true)
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
    cell_validate if(self.valid == true)
  end

  def cell_validate
    height = 2 * self.down - 1
    width = 2 * self.across - 1
    for i in (1..height).step(2) do
      for j in (1..width).step(2) do
        wall_num = calculate_boundary_sum(i,j)
        if(wall_num == 4 || wall_num == 0)
          puts "[#{i},#{j}] is an invalid cell. Please enter another valid string"
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
    wall_num = 0 if(self.plane[i-1][j-1] == 0 || self.plane[i-1][j+1] == 0||self.plane[i+1][j-1] == 0||self.plane[i+1][j+1] == 0)
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

  def display; puts graph.map { |x| x.join(' ') } end

  def solve(begX, begY, endX, endY); MazeSolver.new(plane,graph).solve(begX, begY, endX, endY) end

  def trace(begX, begY, endX, endY); MazeSolver.new(plane,graph).trace(begX, begY, endX, endY) end

  def redesign(); load(MazeRedesign.new(across,down).produce) end

end
