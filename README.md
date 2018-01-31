# pa-mazes

## Author
Zhengyang Zhou


## Brief introduction
A simple command-respond tool for creating and solving mazes

## Getting Started
Run “ruby maze_run.rb” on terminal
As for testing file, please gem install o_stream_catcher first, which I have already included in gem file.

## Design Solution
There are three parts: the maze_run (driver class containing the loop), the maze to handle the maze creation as well as client request, the maze_solver to maze_solver whether there is a path between two points, and the maze_redesign to generate a valid string for a maze. 

        Class maze_run : get input from the user repeatedly until user type “exit”
        Class maze : Handle the client request and validation of input string. The functions include, create maze, load a string,display the graph, solve and trace whether path exists between two points, as well as redesign the maze.
        Class maze_solver: Use Breadth first search to find the path
        Class maze_redesign: Use Depth first search to generate a valid string for the maze

## Interesting Idea:
   1.	The reason I prefer breadth first search in finding the path is that DFS is more riskier and like a gambling to focus one path at a time. However, I think I can cooperate greedy algorithm into my program, as the way it considers the cost is more efficient.
   2.	The way I implemented redesign is to ramdonly set a start and end points, as well as making all the non-cell unit as wall first. And then I used depth first search to make sure there has to be a way between any two points if they are neighbours. As a result, any two points in the graph can reach each other. In this case, I can only generate valid string without two points can't reach from each other. Looking for further improvement to produce valid strings that includes some points can't getting to each other. 
        

## Command Note:
1. Before and after each maze action, the prompt will ask you whether you want to exit. Type "exit" when you want to exit and any other things to continue.
2. When entering begin points and end points, make sure use a space (' ') to separate begX, begY, endX, and endY
3. When the prompt asks you whether to redesign or solve other points, type 'Y' to continue and other things to reject.
4. You can also select size-orientated or string-orientated. If you choose the former one, the prompt will ask you about the across and down length; if you choose the latter one, the prompt will ask you to input a string.

## Testing:
        maze_test.rb and maze_initialize_load_test.rb are the testing files


