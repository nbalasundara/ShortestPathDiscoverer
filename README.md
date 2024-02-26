# ShortestPathDiscoverer
This is an iOS app to find the shortest path in a grid from left to right where the rows wrap around.

The program finds the path of lowest cost when moving across a grid. The grid contains integers where each integer represents the amount of cost encountered at a given point on the grid. A path enters the grid from the left (at any point) and passes through the grid to the right, moving only one column per round. Movement is always to the same row or an adjacent row, meaning the path can proceed horizontally or diagonally. The first and last row are considered adjacent. Effectively, the grid “wraps”. Grid entries can be both negative and positive. The search stops when the total cost of any path to the right most edge exceeds 50.

The app screen has three sections.

The top section provides instructions as to how to enter grid entries. 

The middle section is provided to enter the grid one row perline with column values separated by space(' ')
such as:
1 2 3
4 5 6

Once the grid values are entered, tap on the 'Find The Shortest Path' button.

The answer is presented with the first line is either “Yes” or “No” to indicate the path made it all the way through the grid. The second line is the total cost. The third line shows the path taken as a sequence of n delimited integers, each representing the rows traversed in turn. If there is more than one path of least cost, only one path is shown in the solution.
