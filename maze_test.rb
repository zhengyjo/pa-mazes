require "minitest/autorun"
require 'o_stream_catcher'
require_relative "maze"

#Zhengyang Zhou
#Test all display, solve, trace and redesign.
describe Maze do

  before do
    @four_by_four = Maze.new(4,4)
    @arg = "111111111100010001111010101100010101101110101100000101111111101100000101111111111"
    @arg_arr = @arg.split("")
    @four_by_four.load(@arg)
  end

  it "can display the diagram of a maze" do
    #Generate a correct graph for comparison later
    correct_graph = Array.new((2 * (4) + 1)){Array.new((2 * (4) + 1),"")}
    for i in 0..(@arg_arr.length-1) do
      row = i / (2 * (4) + 1)
      col = i % (2 * (4) + 1)
      @arg_arr[i].to_i == 1? correct_graph[row][col] = '*': correct_graph[row][col] = ' '
    end
    @four_by_four.graph.must_equal correct_graph
    result, stdout, stderr = OStreamCatcher.catch do
      @four_by_four.display
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts correct_graph.map { |x| x.join(' ') }
    end
    stdout.must_equal(stdout2)
  end

  it "can solve a reachable pair of points" do
    correct_direction = [[0, 0], [1, 0], [1, 1], [0, 1], [0, 2], [1, 2], [2, 2], [2, 1], [2, 0], [3, 0], [3, 1], [3, 2], [3, 3]]
    path,trans = @four_by_four.solve(0,0,3,3)
    path.must_equal(correct_direction)
  end

  it "will return empty array if two points are not reachable from each other" do
    correct_direction = []
    path,trans = @four_by_four.solve(0,0,2,3)
    path.must_equal(correct_direction)
  end

  it "can trace the reachable points case 1" do
    #Generate a correct path with @ representing the path
    correct_graph = Array.new((2 * (4) + 1)){Array.new((2 * (4) + 1),"")}
    for i in 0..(@arg_arr.length-1) do
      row = i / (2 * (4) + 1)
      col = i % (2 * (4) + 1)
      @arg_arr[i].to_i == 1? correct_graph[row][col] = '*': correct_graph[row][col] = ' '
    end
    correct_trans = [[1, 3], [2, 3], [3, 3], [3, 2], [3, 1], [4, 1], [5, 1]]
    for element in correct_trans do
      correct_graph[element[0]][element[1]] = '@'
    end
    result, stdout, stderr = OStreamCatcher.catch do
      @four_by_four.trace(1,0,0,2)#Trace it by the maze operation
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts correct_graph.map { |x| x.join(' ') }
    end
    stdout.must_equal(stdout2)
  end

  it "can trace the reachable points case 2" do
    #Generate a correct path with @ representing the path
    correct_graph = Array.new((2 * (4) + 1)){Array.new((2 * (4) + 1),"")}
    for i in 0..(@arg_arr.length-1) do
      row = i / (2 * (4) + 1)
      col = i % (2 * (4) + 1)
      @arg_arr[i].to_i == 1? correct_graph[row][col] = '*': correct_graph[row][col] = ' '
    end
    correct_trans = [[1, 1], [1, 2], [1, 3], [2, 3], [3, 3], [3, 2], [3, 1], [4, 1], [5, 1], [5, 2], [5, 3], [5, 4], [5, 5], [4, 5], [3, 5], [2, 5], [1, 5], [1, 6], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7]]
    for element in correct_trans do
      correct_graph[element[0]][element[1]] = '@'
    end
    result, stdout, stderr = OStreamCatcher.catch do
      @four_by_four.trace(0,0,3,3)#Trace it by the maze operation
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts correct_graph.map { |x| x.join(' ') }
    end
    stdout.must_equal(stdout2)
  end

  it "can do the redesign" do
    @four_by_four.redesign
    @four_by_four.valid.must_equal true #Whether the generated string is valid
    puts "\n"
    @four_by_four.display
  end

end
