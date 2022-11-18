import argparse
import os
from typing import List, Tuple

GCC_INCLUDE_PATH_PLACEHOLDER = "GCC_INCLUDE_PATH_PLACEHOLDER"
LINUX_SRC_PATH_PLACEHOLDER = "LINUX_SRC_PATH_PLACEHOLDER"
ROOT_USER_PASSWORD_PLACEHOLDER = "ROOT_USER_PASSWORD_PLACEHOLDER"
HOME_DIRECTORY_PLACEHOLDER = "HOME_DIRECTORY_PLACEHOLDER"
HOME_DIRECTORY_PLACEHOLDER="HOME_DIRECTORY_PLACEHOLDER"
BUILDROOT_IMAGES_PATH_PLACEHOLDER="IMAGES_DIRECTORY_PLACEHOLDER"
KERNEL_MODULE_NAME_PLACEHOLDER="KERNEL_MODULE_NAME_PLACEHOLDER"
SNAPSHOT_NAME_PLACEHOLDER="SNAPSHOT_NAME_PLACEHOLDER"

C_CPP_PROPERTIES_PATH = ".vscode/c_cpp_properties.json"
DEBUG_SCRIPT_PATH = "debug.sh"
MAKEFILE_PATH = "Makefile"

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--linux-src", type=str, required=True, help="Path to buildroot's downloaded kernel source code. /path/to/buildroot/output/build/linux-<linux={version}>")
    parser.add_argument("--gcc-include-path", type=str, help="Path to gcc library header")
    parser.add_argument("--guest-root-password", type=str, required=True, help="Password to the qemu vm's root user")
    parser.add_argument("--snapshot", type=str, required=True, help="Qemu snapshot name to restore to")
    parser.add_argument("--module-name", type=str, default="kernel_development", help="The developed module's name")
    return parser.parse_args()

def inplace_change(filename, replace_pairs: List[Tuple]):
    strings_to_replace = [replace_pair[0] for replace_pair in replace_pairs]
    with open(filename) as f:
        s = f.read()
        for string_to_replace in strings_to_replace:
            if string_to_replace not in s:
                return

    with open(filename, 'w') as f:
        for replace_pair in replace_pairs:
            s = s.replace(replace_pair[0], replace_pair[1])
        f.write(s)

def main():
    args = parse_args()
    home_directory = os.path.expanduser('~')
    images_path = os.path.join(os.path.dirname(os.path.dirname(args.linux_src)), "images")

    inplace_change(C_CPP_PROPERTIES_PATH, [(LINUX_SRC_PATH_PLACEHOLDER, args.linux_src), (GCC_INCLUDE_PATH_PLACEHOLDER, args.gcc_include_path)])
    inplace_change(DEBUG_SCRIPT_PATH, [(HOME_DIRECTORY_PLACEHOLDER, home_directory), 
                                       (BUILDROOT_IMAGES_PATH_PLACEHOLDER, images_path),
                                       (ROOT_USER_PASSWORD_PLACEHOLDER, args.guest_root_password),
                                       (KERNEL_MODULE_NAME_PLACEHOLDER, args.module_name),
                                       (SNAPSHOT_NAME_PLACEHOLDER, args.snapshot)])
    inplace_change(MAKEFILE_PATH, [(KERNEL_MODULE_NAME_PLACEHOLDER, args.module_name),
                                   (LINUX_SRC_PATH_PLACEHOLDER, args.linux_src)])

if __name__ == "__main__":
    main()