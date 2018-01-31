require "minitest/autorun"
require 'o_stream_catcher'
require_relative "maze"
#Zhengyang Zhou
#Test create maze and load function
describe Maze do

  it "can initialize a maze" do
    four_by_four = Maze.new(4,4)
    four_by_four.across.must_equal  4
    four_by_four.down.must_equal  4
    four_by_four.length.must_equal  81
    four_by_four.plane.must_equal(Array.new((2 * (4) + 1)){Array.new((2 * (4) + 1),0)})
  end

  it "can load a string" do
    four_by_four = Maze.new(4,4)
    arg = "111111111100010001111010101100010101101110101100000101111111101100000101111111111"
    four_by_four.load(arg)
    arg_arr = arg.split("")
    correct_matrix = (Array.new((2 * (4) + 1)){Array.new((2 * (4) + 1),0)})
    for i in 0..(arg_arr.length-1) do
      row = i / (2 * (4) + 1)
      col = i % (2 * (4) + 1)
      correct_matrix[row][col] = arg_arr[i].to_i
    end
    four_by_four.plane.must_equal(correct_matrix)
  end

  it "can validate whether the input string has proper length" do
    one_by_one = Maze.new(1,1)
    arg = "1111011111"#The length is ten, which is not correct, as the formula is (2*across+1)*(2*down+1)
    result, stdout, stderr = OStreamCatcher.catch do
      one_by_one.load(arg)
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts "The length of the string is not correct. Your input length is 10 but the length needs to be 9"
    end
    stdout.must_equal(stdout2)
  end

  it "can validate whether the input string contains valid charater" do
    one_by_one = Maze.new(1,1)
    arg = "345345345"#3,4,5 is not valid character
    result, stdout, stderr = OStreamCatcher.catch do
      one_by_one.load(arg)
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts "The input argument contain(s) characters other than 0 and 1. Please correct!"
    end
    stdout.must_equal(stdout2)
  end

  it "can validate whether the maze is correctly closed" do
    one_by_one = Maze.new(1,1)
    arg = "011101111"#The top line is not closed
    result, stdout, stderr = OStreamCatcher.catch do
      one_by_one.load(arg)
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts "One of the boundaries is not closed"
    end
    stdout.must_equal(stdout2)
  end

  it "can validate whether the maze contains dead or empty cell" do
    three_by_one = Maze.new(3,1)
    arg = "111111110100011111111"#The first cell is dead, as it surrounded by 4 walls.
    result, stdout, stderr = OStreamCatcher.catch do
      three_by_one.load(arg)
    end
    result, stdout2, stderr = OStreamCatcher.catch do
      puts "[0,0] is an invalid cell. Please enter another valid string"
    end
    stdout.must_equal(stdout2)
  end

end
