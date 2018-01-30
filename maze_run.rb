require './maze.rb'

PROMPT = '>'

def load_input(maze)
  puts "Enter the input string"
  print PROMPT
  input = $stdin.gets.chomp.downcase
  maze.load(input)
  puts "Here is the graph of the maze"
  maze.display if(maze.valid == true)
end

def solve_maze(maze)
  puts "Enter begin X, begin Y, end X, end Y. Separated by a space respectively"
  input = $stdin.gets.chomp.downcase.split(" ")
  if(input.length == 4 && /\A\d+\z/.match(input[0]) && /\A\d+\z/.match(input[1])&& /\A\d+\z/.match(input[2]) && /\A\d+\z/.match(input[3]))
    path,trans = maze.solve(input[0].to_i,input[1].to_i,input[2].to_i,input[3].to_i)
    if(path != [])
      puts "Here is the path and trace from begin to end"
      puts path.to_s
      maze.trace(input[0].to_i,input[1].to_i,input[2].to_i,input[3].to_i)
    else
      puts "There is no way from input begin to end"
    end
  else
    puts "Invalid input point(s)"
  end
end

def solve_and_redesign(maze)
  loop do
    loop do
      solve_maze(maze)
      puts "wanna try other points? Type 'Y' to continue. Remember, this is a #{maze.across} * #{maze.down} maze with 0 base"
      print PROMPT
      input = $stdin.gets.chomp.downcase
      break if input != 'y'
    end
    puts "Wanna redesign the maze? Type 'Y' to continue. Remember, this is a #{maze.across} * #{maze.down} maze with 0 base"
    print PROMPT
    input = $stdin.gets.chomp.downcase
    break if input != 'y'
    maze.redesign
    maze.display
  end
end

def maze_gaming(across,down,op)
  maze = Maze.new(across,down)
  if(op == 'size')
    load_input(maze)
  else
    maze.load(op)
    maze.display if(maze.valid == true)
  end
  if(maze.valid == true)
    solve_and_redesign(maze)
  end
end

def size_orientated_maze
  puts "Enter the across length and down length you want. Separate by a space"
  input = $stdin.gets.chomp.downcase.split(" ")
  if(input.length == 2 && /\A\d+\z/.match(input[0]) && /\A\d+\z/.match(input[1]))
    maze_gaming(input[0].to_i,input[1].to_i,'size')
  else
    puts "Invalid input."
  end
end

def validate_string(arg)
   arg.split("").each do |i|
      if(i != '0' && i !='1')
        puts "The input argument contain(s) characters other than 0 and 1. Please correct!"
        return false
      end
    end
end

def string_orientated_maze
  puts "Enter the string you want to try to build a maze with"
  input = $stdin.gets.chomp.downcase
  if(validate_string(input))
    across = input.split("").index{|x|x== "0"} -1
    down = input.length / across
    maze_gaming(across/2,down/2,input)
  else
    puts "Invalid String input"
  end
end

def maze_choice(input)
  if(input == '1')
    size_orientated_maze
  elsif(input == '2')
    string_orientated_maze
  end
end

def process
  puts 'Welcome to the little maze program. If you want to exit,type "exit", otherwise,type any other things to continue '
  print PROMPT
  input = $stdin.gets.chomp.downcase

  while input != 'exit'
    puts "If you want to want to set the size of the maze first, press '1'; if you want to input a string directly, press '2'"
    input = $stdin.gets.chomp.downcase
    maze_choice(input)
    puts "If you want to quit, please enter 'exit'. otherwise, type any other things"
    print PROMPT
    input = $stdin.gets.chomp.downcase
  end
  puts "Good Bye!"
end

process
