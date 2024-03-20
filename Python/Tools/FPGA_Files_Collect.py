
import os
import shutil

# Base path where the source and target directories are located
base_path = 'C:/Users/rgrov/OneDrive - Bit-Wise Automation LLC/GitHub/ProjectPolyglot/FPGA/ECE530-Digital Hardware Design/Proj-3_AES/'
source_directories = {
    'constrs_1': 'Constraints',
    'sim_1': 'Simulations',
    'sources_1': 'Sources'
}

# Path to the directory
code_dest_path = os.path.join(base_path, 'Code-AES')

# Ensure the  directory exists
os.makedirs(code_dest_path, exist_ok=True)

code_source_path = os.path.join(code_dest_path, 'AES.srcs')
os.makedirs(code_source_path, exist_ok=True)

# Function to copy contents of one folder to another

# Function to copy only files from the source folder to the destination folder
def copy_files(src_folder, dst_folder):
    for item in os.listdir(src_folder):
        src_item_path = os.path.join(src_folder, item)
        if os.path.isfile(src_item_path):
            shutil.copy(src_item_path, dst_folder)
        elif os.path.isdir(src_item_path):
            os.makedirs(dst_folder, exist_ok=True)
            copy_files(src_item_path, dst_folder)  # Recursive call for sub-folders

# Process each source directory and copy its contents to the corresponding target directory
for src_dir_suffix, target_dir_name in source_directories.items():
    src_dir_path = os.path.join(code_source_path, src_dir_suffix)
    target_dir_path = os.path.join(code_dest_path, target_dir_name)

    # Ensure the target directory exists
    os.makedirs(target_dir_path, exist_ok=True)

    # Copy contents from source to target directory
    copy_files(src_dir_path, target_dir_path)
    print(f'Copied contents of {src_dir_path} to {target_dir_path}')

