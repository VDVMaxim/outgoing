import os
import sys


def build_file_tree(folder):
    tree = ""

    for root, dirs, files in os.walk(folder):
        for file in files:
            file_path = os.path.join(root, file)

            # relative path vanaf root folder
            relative_path = os.path.relpath(file_path, folder)

            tree += relative_path.replace("\\", "/") + "\n"

    return tree


def scan_folder(folder):
    output = ""

    if not os.path.isdir(folder):
        return f"Fout: '{folder}' is geen geldige map.\n"

    # =========================
    # FILE TREE
    # =========================
    output += "=== FILE TREE ===\n\n"
    output += build_file_tree(folder)
    output += "\n"

    # =========================
    # FILE CONTENTS
    # =========================
    output += "=== FILE CONTENTS ===\n\n"

    for root, dirs, files in os.walk(folder):
        for file in files:
            file_path = os.path.join(root, file)

            # relative path vanaf root folder
            relative_path = os.path.relpath(file_path, folder)
            relative_path = relative_path.replace("\\", "/")

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                output += f"{relative_path}:\n"
                output += content + "\n\n"

            except Exception as e:
                output += f"{relative_path}:\n"
                output += f"[Fout bij lezen: {e}]\n\n"

    return output


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Gebruik: python3 scan.py <map> [outputbestand]")
        sys.exit(1)

    folder = sys.argv[1]
    result = scan_folder(folder)

    # Als er een outputbestand is opgegeven
    if len(sys.argv) == 3:
        output_file = sys.argv[2]

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(result)

        print(f"Output geschreven naar '{output_file}'")

    else:
        print(result)