import kociemba
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches
import random



possible_moves = ['R', 'L', 'U', 'D', 'F', 'B', 'nR', 'nL', 'nU', 'nD', 'nF', 'nB']

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

        # Define color codes based on your color mapping
        color_codes = {
            1: 'White',  # U
            2: 'Green',  # F
            3: 'Red',    # R
            4: 'Blue',   # B
            5: 'Yellow', # D
            6: 'Orange'  # L
        }
        
        # Count occurrences of each color code
        color_counts = {color: np.count_nonzero(all_cells == code) for code, color in color_codes.items()}

        # Check that each color appears exactly 9 times
        for color, count in color_counts.items():
            if count != 9:
                raise ValueError(f"Invalid color count: {color} appears {count} times instead of 9")

    def is_solved(self):
        #Check if the cube is solved (each face has a uniform color).
        #Return 1 if solved, 0 otherwise.
        
        for face in self.state:
            if not np.all(face == face[0,0]):
                return 0
        return 1

    def randomize(self, num_moves=100):
        #Apply a series of random moves to scramble the cube.
        
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

def flatten_cube_state(cube):
    # Map numbers to cube face letters (color coding)
    color_mapping = {
        1: 'U', # White
        2: 'F', # Green
        3: 'R', # Red
        4: 'B', # Blue
        5: 'D', # Yellow
        6: 'L'  # Orange
    }
    faces_order = ['U', 'R', 'F', 'D', 'L', 'B']
    state_string = ''
    for face in faces_order:
        index = {'U': 0, 'R': 2, 'F': 1, 'D': 4, 'L': 5, 'B': 3}[face]
        for row in cube.state[index]:
            for val in row:
                state_string += color_mapping[val]
    return state_string

def solve_rubiks_cube(cube_state):
    
    try:
        solution = kociemba.solve(cube_state)
        return solution
    except Exception as e:
        return str(e)

def convert_cube_notation(algorithm):
    result = ""  # Initialize the result string
    
    i = 0  # Start with the first character of the input string
    while i < len(algorithm):
        if i+1 < len(algorithm) and algorithm[i+1] == '2':
            # If the next character is '2', append two of the current character
            result += algorithm[i] * 2
            i += 2  # Skip the next character since it's a '2'
        elif i+1 < len(algorithm) and algorithm[i+1] == "'":
            # If the next character is an apostrophe, append the current character in lowercase
            result += algorithm[i].lower()
            i += 2  # Skip the next character since it's a "'"
        else:
            # Otherwise, append the current character as it is
            result += algorithm[i]
            i += 1
    
    result=result.replace(" ", "")
    return result

def convert_my_format_to_standard(moves):
    result = []  # Initialize an empty list to collect moves
    
    # Remove single quotes and split the string into individual moves
    moves = moves.replace("'", "").split()
    for move in moves:
        move = move.replace("[","")
        move = move.replace("]","")
        if move.startswith('n'):
            # If the move starts with 'n', append the move as lowercase (inverted move)
            result.append(move[1].lower())
        else:
            # Otherwise, append the move as it is (regular move)
            result.append(move)
    
    # Join all parts with a space and return
    return ' '.join(result)

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

'''
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

cube.perform_moves(['D', 'D', 'R', 'R', 'U', 'U', 'R', 'R', 'R', 'B', 'B', 'R', 'F', 'F'])
#plot_cube(cube.state)
#current_moves = cube.randomize(50)
#moves = convert_my_format_to_standard(str(current_moves))
#moves = moves.replace(" ","")
#print( moves)
#print()
#print("Random Moves")
#print(current_moves)
#plot_cube(cube.state)


print(flatten_cube_state(cube))
solution = solve_rubiks_cube(flatten_cube_state(cube))
print("Solution:", solution)
solution = convert_cube_notation(solution)
solution=solution.replace(" ", "")
print("Solution (My Format):", solution)
'''