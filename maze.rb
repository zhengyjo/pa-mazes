require './maze_solver.rb'
require './maze_redesign.rb'
# Zhengyang Zhou
# The maze class to handle functions requested
# Attributes introduction:
# Plane:a 2-d array to load the input string contains only 0 and 1
# graph:a 2-d array to present wall and cell
# valid: whether the loaded string is valid
# across: cell number on across direction
# down: cell number on down direction
# length: valid string length, including wall and cell, formula is (2*across+1)*(2*down+1)
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
    if(first_validate_arg(arg)) # First layer validation
      arg_arr = arg.split("")
      for i in 0..(self.length-1) do
        row = i / (2 * (self.across) + 1)
        col = i % (2 * (self.across) + 1)
        plane[row][col] = arg_arr[i].to_i
      end
      second_validate # Second layer validation
      draw_graph if(self.valid == true) # Fill out the graph if the input string is valid
    end
  end

  # First layer validation: check the length of string, and existence of the character other than 0  or 1
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

  #Second layer validation: check the boundaries on top, down, left, and right.
  #Then check whether each cell is surrounded by 1 to 3 cell
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

  # Subfunction to check whether cell is surrounded by 1 to 3 cell
  def cell_validate
    height = 2 * self.down - 1
    width = 2 * self.across - 1
    for i in (1..height).step(2) do
      for j in (1..width).step(2) do
        wall_num = calculate_boundary_sum(i,j)
        if(wall_num == 4 || wall_num == 0)
          puts "[#{j/2},#{i/2}] is an invalid cell. Please enter another valid string"
          self.valid = false
        end
      end
    end
  end

  #Calculate the wall number for cell
  def calculate_boundary_sum(i,j)
    wall_num = 0
    self.plane[i-1][j-1..j+1].sum == 3? wall_num += 1: wall_num
    self.plane[i+1][j-1..j+1].sum == 3? wall_num += 1: wall_num
    self.plane[i-1..i+1].map{|a| a[j-1]}.sum == 3? wall_num += 1: wall_num
    self.plane[i-1..i+1].map{|a| a[j+1]}.sum == 3? wall_num += 1: wall_num
    wall_num = 0 if(self.plane[i-1][j-1] == 0 || self.plane[i-1][j+1] == 0||self.plane[i+1][j-1] == 0||self.plane[i+1][j+1] == 0)
    return wall_num
  end

  # Fulfill the graph with '*'' as wall and ' ' as cell
  def draw_graph
    @graph = Array.new((2 * (self.down) + 1)){Array.new((2 * (self.across) + 1),"")}
    for i in 0..(2 * (self.down)) do
      for j in 0..(2 * (self.across)) do
        plane[i][j] == 1? graph[i][j] = '*': graph[i][j] = ' '
      end
    end
  end

  # Display the graph
  def display; puts graph.map { |x| x.join(' ') } end

  # Call the maze_solver class to see whether there is path between two points.
  def solve(begX, begY, endX, endY); MazeSolver.new(plane,graph).solve(begX, begY, endX, endY) end

  # Call the maze_solver class to trace path between two points.
  def trace(begX, begY, endX, endY); MazeSolver.new(plane,graph).trace(begX, begY, endX, endY) end

  # Call the maze_redesign class to generate a valid string for this maze.
  def redesign(); load(MazeRedesign.new(across,down).produce) end

end
