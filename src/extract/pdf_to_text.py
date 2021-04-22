import pdfplumber
import os

# Give the file path of pdf that you want to extract
filepath = os.path.abspath(__file__ + "/../../../")
filename = os.path.join(filepath, "data\Spencer Johnson - Who Moved My Cheese.pdf")
print(filename)

outpath = os.path.abspath(__file__ + "/../../../")
outfilename = os.path.join(outpath, "out\who_moved_my_cheese.txt")
print(outfilename)


with open(outfilename, "a") as f:
    with pdfplumber.open(filename) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            print(text)
            f.write(str(text) + '\n')
f.close()