import numpy as np
import sys
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import random
import time
from numba import jit
from multiprocessing import Pool
import cProfile



possible_moves = ['R', 'L', 'U', 'D', 'F', 'B', 'nR', 'nL', 'nU', 'nD', 'nF', 'nB']
move_pairs = {'R': 'nR', 'nR': 'R', 'L': 'nL', 'nL': 'L', 'U': 'nU', 'nU': 'U', 'D': 'nD', 'nD': 'D', 'F': 'nF', 'nF': 'F', 'B': 'nB', 'nB': 'B'}


class RubiksCube:
    def __init__(self, state):
        self.state = state  # state is a list of 6 matrices (3x3), representing each face of the cube
        self.moves_map = {
            'R': self.R, 'L': self.L, 'U': self.U, 'D': self.D,
            'F': self.F, 'B': self.B,
            'nR': self.nR, 'nL': self.nL, 'nU': self.nU, 'nD': self.nD,
            'nF': self.nF, 'nB': self.nB,
        }

    def rotate_face_clockwise(self, face):
        # Rotates a face (3x3 matrix) clockwise
        return  np.rot90(face,k=1,axes=(1,0))

    def rotate_face_counterclockwise(self, face):
        # Rotates a face (3x3 matrix) counterclockwise
        return  np.rot90(face,k=1,axes=(0,1))
    
    def nR(self):
        # Rotate Right face counter-clockwise
        self.state[2] = self.rotate_face_counterclockwise(self.state[2])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets left column of Back face
        self.state[0,:,2] = [temp[3,2-i,0] for i in range(3)]

        # Front column of Front face gets top row of Up face
        self.state[1,:,2] = temp[0,:,2]

        # Bottom row of Down face gets front column of Front face
        self.state[4,:,2] = temp[1,:,2]

        # Back column of Back face gets bottom row of Down face
        self.state[3,:,0] = [temp[4,2-i,2] for i in range(3)]

    def nL(self):
        # Rotate Left face counter-clockwise
        self.state[5] = self.rotate_face_counterclockwise(self.state[5])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets front column of Front face
        self.state[0,:,0] = temp[1,:,0]

        # Left column of Front face gets left column of Down face
        self.state[1,:,0] = temp[4,:,0]

        # Left column of Down face gets right column of Back face
        self.state[4,:,0] = [temp[3,2-i,2] for i in range(3)]

        # Back column of Back face (reversed order) gets top row of Up face
        self.state[3,:,2] = [temp[0,2-i,0] for i in range(3)]

    def nU(self):
        # Rotate Up face counter-clockwise
        self.state[0] = self.rotate_face_counterclockwise(self.state[0])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Front face gets top row of Left face
        self.state[1,0,:] = temp[5,0,:]

        # Top row of Right face gets top row of Front face
        self.state[2,0,:] = temp[1,0,:]

        # Top row of Back face gets top row of Right face
        self.state[3,0,:] = temp[2,0,:]

        # Top row of Left face gets top row of Back face
        self.state[5,0,:] = temp[3,0,:]

    def nD(self):
        # Rotate Down face counter-clockwise
        self.state[4] = self.rotate_face_counterclockwise(self.state[4])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Bottom row of Front face gets bottom row of Right face
        self.state[1,2,:] = temp[2,2,:]

        # Bottom row of Right face gets bottom row of Back face
        self.state[2,2,:] = temp[3,2,:]

        # Bottom row of Back face gets bottom row of Left face
        self.state[3,2,:] = temp[5,2,:]

        # Bottom row of Left face gets bottom row of Front face
        self.state[5,2,:] = temp[1,2,:]
    
    def nF(self):
        # Rotate Front face counter-clockwise
        self.state[1] = self.rotate_face_counterclockwise(self.state[1])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Bottom row of Up face gets left column of Right face
        self.state[0,2,:] = [temp[2,i,0] for i in range(3)]

        # Left column of Right face gets top row of Down face
        self.state[2,:,0] = [temp[4,0,2-i] for i in range(3)]

        # Top row of Down face gets right column of Left face
        self.state[4,0,:] = [temp[5,i,2] for i in range(3)]

        # Right column of Left face gets bottom row of Up face
        self.state[5,:,2] = [temp[0,2,2-i] for i in range(3)]

    def nB(self):
        # Rotate Back face counter-clockwise
        self.state[3] = self.rotate_face_counterclockwise(self.state[3])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets left column of Left face (in reverse)
        self.state[0,0,:] = [temp[5,2-i,0] for i in range(3)]

        # Left column of Left face gets bottom row of Down face
        self.state[5,:,0] = [temp[4,2,i] for i in range(3)]

        # Bottom row of Down face gets right column of Right face (in reverse)
        self.state[4,2,:] = [temp[2,2-i,2] for i in range(3)]

        # Right column of Right face gets top row of Up face
        self.state[2,:,2] = [temp[0,0,i] for i in range(3)]

    def R(self):
        # Rotate Right face clockwise
        self.state[2] = self.rotate_face_clockwise(self.state[2])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets front column of Front face
        self.state[0,:,2] = temp[1,:,2]

        # Front column of Front face gets bottom row of Down face
        self.state[1,:,2] = temp[4,:,2]

        # Bottom row of Down face gets back column of Back face (reversed order)
        self.state[4,:,2] = [temp[3,2-i,0] for i in range(3)]

        # Back column of Back face gets top row of Up face
        self.state[3,:,0] = [temp[0,2-i,2] for i in range(3)]

    def L(self):
        # Rotate Left face clockwise
        self.state[5] = self.rotate_face_clockwise(self.state[5])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets back column of Back face
        self.state[0,:,0] = [temp[3,2-i,2] for i in range(3)]

        # Front column of Front face gets top row of Up face
        self.state[1,:,0] = temp[0,:,0]

        # Bottom row of Down face gets front column of Front face
        self.state[4,:,0] = temp[1,:,0]

        # Back column of Back face  gets bottom row of Down face
        self.state[3,:,2] = [temp[4,2-i,0] for i in range(3)]

    def U(self):
        # Rotate Up face clockwise
        self.state[0] = self.rotate_face_clockwise(self.state[0])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Front face gets top row of Right face
        self.state[1,0,:] = temp[2,0,:]

        # Top row of Right face gets top row of Back face
        self.state[2,0,:] = temp[3,0,:]

        # Top row of Back face gets top row of Left face
        self.state[3,0,:] = temp[5,0,:]

        # Top row of Left face gets top row of Front face
        self.state[5,0,:] = temp[1,0,:]

    def D(self):
        # Rotate Down face clockwise
        self.state[4] = self.rotate_face_clockwise(self.state[4])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Bottom row of Front face gets bottom row of Left face
        self.state[1,2,:] = temp[5,2,:]

        # Bottom row of Right face gets bottom row of Front face
        self.state[2,2,:] = temp[1,2,:]

        # Bottom row of Back face gets bottom row of Right face
        self.state[3,2,:] = temp[2,2,:]

        # Bottom row of Left face gets bottom row of Back face
        self.state[5,2,:] = temp[3,2,:]

    def F(self):
        # Rotate Front face clockwise
        self.state[1] = self.rotate_face_clockwise(self.state[1])

        # Adjust the surrounding faces
        temp = self.state.copy() 

        # Bottom row of Up face gets right column of Left face
        self.state[0,2,:] = [temp[5,2-i,2] for i in range(3)]

        # Right column of Right face gets top row of Up face
        self.state[2,:,0] = [temp[0,2,i] for i in range(3)]

        # Bottom row of Down face gets right column of Right face
        self.state[4,0,:] = [temp[2,2-i,0] for i in range(3)]

        # Left column of Left face gets bottom row of Down face
        self.state[5,:,2] = [temp[4,0,i] for i in range(3)]

    def B(self):
        # Rotate Back face clockwise
        self.state[3] = self.rotate_face_clockwise(self.state[3])

        # Adjust the surrounding faces
        temp = self.state.copy()

        # Top row of Up face gets right column of Right face
        self.state[0,0,:] = [temp[2,i,2] for i in range(3)]

        # Right column of Right face gets bottom row of Down face
        self.state[2,:,2] = [temp[4,2,2-i] for i in range(3)]

        # Bottom row of Down face gets left column of Left face
        self.state[4,2,:] = [temp[5,i,0] for i in range(3)]

        # Left column of Left face gets top row of Up face (reversed)
        self.state[5,:,0] = [temp[0,0,2-i] for i in range(3)]

    def perform_moves(self, moves):
        # Perform a sequence of moves
        for move in moves:
            if move in self.moves_map:
                self.moves_map[move]()
            else:
                raise ValueError(f"Invalid move: {move}")

    def display(self):
        # Display the current state of the cube
        for face in self.state:
            for row in face:
                print(' '.join(row))
            print()

    def check_color_count(self):
        
        #Check that there are exactly 9 cells of each color.
        
        # Flatten the state to a single list
        all_cells = self.state.flatten()
        
        # Count occurrences of each color
        color_counts = {color: np.count_nonzero(all_cells == color) for color in 'WROGBY'}
        
        # Check that each color appears exactly 9 times
        for color, count in color_counts.items():
            if count != 9:
                raise ValueError(f"Invalid color count: {color} appears {count} times instead of 9")

    def is_solved(self):
        """
        Check if the cube is solved (each face has a uniform color).
        Return 1 if solved, 0 otherwise.
        """
        for face in self.state:
            if not np.all(face == face[0,0]):
                return 0
        return 1

    def randomize(self, num_moves=100):
        """
        Apply a series of random moves to scramble the cube.
        """
        moves = np.array([])
        for _ in range(num_moves):
            move = random.choice(possible_moves)
            moves = np.append(moves,move)
            getattr(self, move)()
        return moves

def plot_cube(cube_state):
    #print('plot_cube')
    #print(cube_state)
    fig, ax = plt.subplots(figsize=(6, 3.5))
    
    # Set the background color of the axes to grey
    fig.patch.set_facecolor('grey')

    # Define the colors you will use
    color_mapping = {
        1: 'white',
        3: 'red',
        2: 'green',
        4: 'blue',
        5: 'yellow',
        6: 'orange'
    }
    
    # Define the order of the faces as they would be unfolded
    face_order = ['U', 'L', 'F', 'R', 'B', 'D']
    face_indices = {'U': 0, 'L': 5, 'F': 1, 'R': 2, 'B': 3, 'D': 4}
    
    # Define the positions of each face in the plot
    face_positions = {
        'U': (3, 6),
        'L': (0, 3),
        'F': (3, 3),
        'R': (6, 3),
        'B': (9, 3),
        'D': (3, 0)
    }
    
    # Size of each small square
    square_size = 1
    
    # Plot each face
    for face_name in face_order:
        face_index = face_indices[face_name]
        face = cube_state[face_index]
        x_offset, y_offset = face_positions[face_name]
        for i in range(3):
            for j in range(3):
                # Create a colored square at the appropriate position
                square = patches.Rectangle(
                    (x_offset + j*square_size, y_offset + i*square_size),
                    square_size, square_size,
                    facecolor=color_mapping[face[2-i][j]]
                )
                ax.add_patch(square)
                
    # Set the aspect of the plot to be equal
    ax.set_aspect('equal')
    
    # After adding all patches (squares), set the axes limits
    ax.set_xlim(0, 12)  # Assuming each face is 3 units wide
    ax.set_ylim(0, 9)   # Assuming the cube's height is 3 units and there are 3 layers
    
    
    # Remove the axes
    plt.axis('off')
    
    # Show the plot
    plt.show()
'''
def solve_cube(cube_state):
    for m1 in possible_moves:
        trial_cube = RubiksCube(cube_state)
        trial_cube.perform_moves([m1])
        if trial_cube.is_solved():
            return [m1]
    
    
    for m1 in possible_moves:
        for m2 in possible_moves:
            trial_cube = RubiksCube(cube_state)
            trial_cube.perform_moves([m1,m2])
            if trial_cube.is_solved():
                return [m1,m2]
    print('+++++++ Cube not solved')
'''


def generate_valid_move_combinations(depth):
    """
    Generate all valid move combinations of a given length (depth).
    A valid combination does not include consecutive moves and their inverses,
    and skips combinations with the same move three times in a row.

    Parameters:
    - depth: The length of the move combinations to generate.

    Returns:
    - A list of valid move combinations, where each combination is a list of moves.
    """
    if depth <= 0:
        return [[]]

    # Generate all possible combinations for the previous depth
    previous_combinations = generate_valid_move_combinations(depth-1)

    valid_combinations = []
    for combo in previous_combinations:
        for move in possible_moves:
            # Check if the last move of the combo is inverse of the current move
            if combo and move_pairs.get(combo[-1]) == move:
                continue  # Skip adding this move to avoid consecutive inverse moves

            # Check if adding this move would result in the same move three times in a row
            if len(combo) >= 2 and combo[-1] == move and combo[-2] == move:
                continue  # Skip adding this move to avoid three in a row

            # Create a new combination by adding the current move to the existing combo
            new_combo = combo + [move]
            valid_combinations.append(new_combo)

    return valid_combinations

def dfs(trial_cube, depth):
        

    valid_moves = generate_valid_move_combinations(depth)
    for m in valid_moves:

        # Perform the move and create a new cube state
        new_cube = RubiksCube(trial_cube.state.copy())
        new_cube.perform_moves(m)
        if new_cube.is_solved():    # Check if the cube is already solved
            return True, m
    
    # If no solution is found within the depth limit, return failure
    return False, []

def solve_cube(cube_state, max_depth=50):
    for depth in range(1, max_depth + 1):
        start_time = time.time()

        trial_cube = RubiksCube(cube_state)
        solved, solution_moves = dfs(trial_cube, depth)

        end_time = time.time()
        duration = end_time - start_time
        print(f"Depth {depth} took {duration:.2f} seconds")
        print("")
        if solved:
            print('Solution')
            print(solution_moves)
            return solution_moves

    print('Cube not solved within depth limit')
    return []

'''
def dfs(trial_cube, moves, depth, last_move=None):
    if trial_cube.is_solved():
        return True, moves
    if depth <= 0:
        return False, moves

    for m in possible_moves:
        if last_move and move_pairs[last_move] == m:
            continue

        new_cube = RubiksCube(trial_cube.state)
        new_cube.perform_moves([m])
        solved, solution_moves = dfs(new_cube, moves + [m], depth - 1, m)

        if solved:
            return True, solution_moves

    return False, []
    
def worker(args):
    try:
        cube_state, depth, moves = args
        trial_cube = RubiksCube(cube_state)
        trial_cube.perform_moves(moves)
        return dfs(trial_cube, moves, depth, moves[-1] if moves else None)
    except Exception as e:
        print(f"Error in worker: {e}")
        return False, []

def solve_cube(cube_state, max_depth=50, num_processes=4):
    # Create a pool of processes
    with Pool(num_processes) as pool:
        for depth in range(1, max_depth + 1):
            start_time = time.time()
            # Create arguments for each process
            args_list = [(cube_state, depth, [m]) for m in possible_moves]

            # Start the pool of processes and collect results
            results = pool.map(worker, args_list)

            end_time = time.time()
            duration = end_time - start_time
            print(f"Depth {depth} took {duration:.2f} seconds")

            # Check if any process solved the cube
            for solved, solution_moves in results:
                if solved:
                    return solution_moves

    print('Cube not solved within depth limit')
    return []

'''



#.state[0] = Up
#.state[1] = Front
#.state[2] = Right
#.state[3] = Back
#.state[4] = Down
#.state[5] = Left

# 1: 'white',
# 3: 'red',
# 2: 'green',
# 4: 'blue',
# 5: 'yellow',
# 6: 'orange'


# Example usage
initial_state = [
[[1, 1, 1], [1, 1, 1], [1, 1, 1]], # Up
[[2, 2, 2], [2, 2, 2], [2, 2, 2]], # Front
[[3, 3, 3], [3, 3, 3], [3, 3, 3]], # Right
[[4, 4, 4], [4, 4, 4], [4, 4, 4]], # Back
[[5, 5, 5], [5, 5, 5], [5, 5, 5]], # Down
[[6, 6, 6], [6, 6, 6], [6, 6, 6]]  # Left
]

initial_state = np.array(initial_state).astype('uint8')



print(initial_state.shape)

cube = RubiksCube(initial_state)
plot_cube(cube.state)
current_moves = cube.randomize(2)
print(current_moves)
plot_cube(cube.state)

solve_cube(cube.state,20)

