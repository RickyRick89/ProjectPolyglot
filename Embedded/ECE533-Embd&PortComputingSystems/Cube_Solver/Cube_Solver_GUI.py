import serial
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from tkinter import Tk, Entry, Text, Button, END, Label, Frame, OptionMenu, StringVar
from threading import Thread
import Cube_Solver_Kociemba
import traceback

# Configuration parameters
serial_port = 'COM11'  
baud_rate = 115200  

# Set up the serial connection
ser = serial.Serial(serial_port, baud_rate, timeout=1)


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

initial_state = [
[[1, 1, 1], [1, 1, 1], [1, 1, 1]], # Up
[[2, 2, 2], [2, 2, 2], [2, 2, 2]], # Front
[[3, 3, 3], [3, 3, 3], [3, 3, 3]], # Right
[[4, 4, 4], [4, 4, 4], [4, 4, 4]], # Back
[[5, 5, 5], [5, 5, 5], [5, 5, 5]], # Down
[[6, 6, 6], [6, 6, 6], [6, 6, 6]]  # Left
]
initial_state = np.array(initial_state).astype('uint8')

cube = Cube_Solver_Kociemba.RubiksCube(initial_state)

# GUI setup
root = Tk()
root.title("UART Communication Interface")

# Organize layout with Frames
top_frame = Frame(root)
top_frame.pack(padx=10, pady=10)

middle_frame = Frame(root)
middle_frame.pack(padx=10, pady=5)

bottom_frame = Frame(root)
bottom_frame.pack(padx=10, pady=10)

# Command text area with label
Label(top_frame, text="Command Output:").pack(side='top')
command_text = Text(top_frame, height=4, width=50)
command_text.pack()

# Entry for number of moves with label
Label(middle_frame, text="Enter Number of Moves:").pack(side='left')
move_count_entry = Entry(middle_frame, width=5)
move_count_entry.pack(side='left')

# Mode selection
mode_var = StringVar(root)
mode_var.set("Image Mode")  # default value
mode_options = ["Image Mode", "Cube State Mode"]
mode_menu = OptionMenu(top_frame, mode_var, *mode_options)
mode_menu.pack(side='top')

def switch_mode():
    current_mode = mode_var.get()
    status_label.config(text=f"Listening on UART for {current_mode.lower()}...")
    # Additional code or refresh mechanism if necessary

# Update the status label when changing modes
mode_var.trace('w', lambda *args: switch_mode())

# Status label
status_label = Label(root, text="Listening on UART for images...")
status_label.pack()

def send_command(command):
    ser.write(command.encode())
    command_text.delete("1.0", END)

def generate_random_moves(cube):
    try:
        move_count = int(move_count_entry.get())
    except ValueError:
        move_count = 20  # Default to 20 moves if entry is not a number
    cube.state = initial_state
    current_moves = cube.randomize(move_count)
    moves = Cube_Solver_Kociemba.convert_my_format_to_standard(str(current_moves))
    moves = moves.replace(" ","")
    moves = moves.replace("[","")
    moves = moves.replace("]","")
    print(moves)

    command_text.delete("1.0", END)
    command_text.insert(END, moves)

def show_image(image):
    
    image_pil = Image.fromarray(np.uint8(image))  # Ensure the image data is in the correct format
    image_resized = image_pil.resize((96, 96), Image.Resampling.LANCZOS)  # Resize the image
    image_resized.save('image_output.png')

    # Display or save the image
    plt.imshow(image_resized)
    plt.axis('off') 
    plt.show()

def solve_cube(cube):
    cube_state = Cube_Solver_Kociemba.flatten_cube_state(cube)
    solution = Cube_Solver_Kociemba.solve_rubiks_cube(cube_state)
    solution = Cube_Solver_Kociemba.convert_cube_notation(solution)
    print(solution)
    command_text.delete("1.0", END)
    command_text.insert(END, solution)


def listen_for_uart_data():
    while True:
        current_mode = mode_var.get()
        if current_mode == "Image Mode":
            try:
                image_data = bytearray()
                while len(image_data) < 27648:
                    data = ser.read(27648 - len(image_data))
                    image_data.extend(data)
                    if mode_var.get() != "Image Mode":
                        print("Mode changed, aborting image read.")
                        break
                if len(image_data) == 27648:
                    image_array = np.frombuffer(image_data, dtype=np.uint8)
                    image_array = image_array.reshape((96, 96, 3))
                    print("Image data received successfully.")
                    root.after(0, lambda: show_image(image_array))
                else:
                    print("Image data read aborted or incomplete.")
            except Exception as e:
                print(f"Error handling image data: {traceback.format_exc()}")

        elif current_mode == "Cube State Mode":
            try:
                cube_data = bytearray()
                while len(cube_data) < 54:
                    data = ser.read(54 - len(cube_data))
                    cube_data.extend(data)
                    if mode_var.get() != "Cube State Mode":
                        print("Mode changed, aborting cube state read.")
                        break
                if len(cube_data) == 54:
                    new_state = np.frombuffer(cube_data, dtype=np.uint8).reshape(6, 3, 3)
                    print(new_state)
                    new_state[new_state == 0] = 1
                    tempcube = Cube_Solver_Kociemba.RubiksCube(new_state)
                    Cube_Solver_Kociemba.plot_cube(tempcube.state)

                    try:
                        tempcube.check_color_count()
                    except ValueError as e:
                        print("Error: Invalid cube state.", e)
                        return  # Abort processing if the cube state is invalid

                    tempcube.perform_moves(['D', 'D', 'R', 'R', 'U', 'U', 'R', 'R', 'R', 'B', 'B', 'R', 'F', 'F'])
                    Cube_Solver_Kociemba.plot_cube(tempcube.state)
                    cube.state = tempcube.state
                    print("Cube state updated from UART data.")
                    solve_cube(cube)
                    send_command(command_text.get("1.0", END).strip())
                else:
                    print("Cube state read aborted or incomplete.")
            except Exception as e:
                print(f"Error receiving cube state: {traceback.format_exc()}")



# Buttons
send_button = Button(bottom_frame, text="Send Command", command=lambda: send_command(command_text.get("1.0", END).strip()))
send_button.pack(side='left', padx=5)

random_moves_button = Button(bottom_frame, text="Generate Random Moves", command=lambda: generate_random_moves(cube))
random_moves_button.pack(side='left', padx=5)

solve_button = Button(bottom_frame, text="Solve Cube", command=lambda: solve_cube(cube))
solve_button.pack(side='left', padx=5)


if __name__ == "__main__":
    thread = Thread(target=listen_for_uart_data, daemon=True)
    thread.start()
    root.mainloop()

