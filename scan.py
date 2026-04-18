import os
import sys

def scan_folder(folder):
    output = ""

    if not os.path.isdir(folder):
        return f"Fout: '{folder}' is geen geldige map.\n"

    for root, dirs, files in os.walk(folder):
        for file in files:
            file_path = os.path.join(root, file)

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                output += f"{file_path}:\n"
                output += content + "\n\n"

            except Exception as e:
                output += f"{file_path}:\n"
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