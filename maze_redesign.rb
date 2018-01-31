#Zhengyang Zhou

class MazeRedesign
  DIRECTIONS = [ [1, 0], [-1, 0], [0, 1], [0, -1] ]

  def initialize(width, height)
    @width   = width
    @height  = height
    @start_x = rand(width)
    @start_y = 0
    @end_x   = rand(width)
    @end_y   = height - 1

    # Which walls do exist? Default to "true". Both arrays are
    # one element bigger than they need to be. For example, the
    # @vertical_walls[x][y] is true if there is a wall between
    # (x,y) and (x+1,y). The additional entry makes producing string easier.
    @vertical_walls   = Array.new(width) { Array.new(height, true) }
    @horizontal_walls = Array.new(width) { Array.new(height, true) }
    # Path for the solved maze.
    #@path             = Array.new(width) { Array.new(height) }
    # Generate the maze.
    generate
  end

  def produce
    output_str = ""
    # Special handling: the top line.
    output_str << @width.times.inject("1") {|str, x| str << "11"}

    # For each cell, attach the right and bottom wall, if it exists.
    @height.times do |y|
      line = @width.times.inject("1") do |str, x|
        str << "0" <<(@vertical_walls[x][y] ? "1" : "0")
      end
      output_str << line

      output_str << @width.times.inject("1") {|str, x| str << (@horizontal_walls[x][y] ? "11" : "01")}
    end
    return output_str
  end

  # Reset the VISITED state of all cells.
  def reset_visiting_state
    @visited = Array.new(@width) { Array.new(@height) }
  end

  # it is valid to connect only when it does step out of the boundary and not visted
  def move_valid?(x, y)
    (0...@width).cover?(x) && (0...@height).cover?(y) && !@visited[x][y]
  end

  # Generate the maze.
  def generate
    reset_visiting_state
    generate_visit_cell(@start_x, @start_y)
  end

  # Depth-first maze generation.
  def generate_visit_cell(x, y)
    # Mark cell as visited.
    @visited[x][y] = true
    # Randomly get coordinates of surrounding cells to explore a path
    coordinates = DIRECTIONS.shuffle.map { |dx, dy| [x + dx, y + dy] }

    for new_x, new_y in coordinates
      next unless move_valid?(new_x, new_y)
      # Recurse if it was possible to connect the current and
      # the cell (this recursion is the "depth-first" part).
      connect_cells(x, y, new_x, new_y)
      generate_visit_cell(new_x, new_y)
    end
  end

  # Try to connect two cells that are neighbours.
  def connect_cells(x1, y1, x2, y2)
    if x1 == x2
      # Cells must be above or below each other, remove a horizontal wall.
      @horizontal_walls[x1][ [y1, y2].min ] = false
    else
      # y1 == y2C ells must be next to each other, remove a vertical wall.
      @vertical_walls[ [x1, x2].min ][y1] = false
    end
  end
end
