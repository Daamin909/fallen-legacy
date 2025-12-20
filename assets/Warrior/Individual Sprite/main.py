from PIL import Image
import os

def autocrop_and_center_inplace(path):
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    px = img.load()

    min_x, min_y = w, h
    max_x, max_y = -1, -1

    for y in range(h):
        for x in range(w):
            if px[x, y][3] != 0:  # alpha != 0
                min_x = min(min_x, x)
                min_y = min(min_y, y)
                max_x = max(max_x, x)
                max_y = max(max_y, y)

    # Fully transparent image → skip
    if max_x == -1:
        return False

    cropped = img.crop((min_x, min_y, max_x + 1, max_y + 1))
    cw, ch = cropped.size

    # Center by padding equally
    new_img = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    new_img.paste(cropped, (0, 0))

    new_img.save(path)
    return True


def process_all_pngs(root="."):
    count = 0
    for dirpath, _, filenames in os.walk(root):
        for file in filenames:
            if file.lower().endswith(".png"):
                full_path = os.path.join(dirpath, file)
                try:
                    if autocrop_and_center_inplace(full_path):
                        print(f"✔ Processed: {full_path}")
                        count += 1
                except Exception as e:
                    print(f"✘ Failed: {full_path} ({e})")

    print(f"\nDone. Processed {count} PNG files.")


if __name__ == "__main__":
    process_all_pngs(".")
