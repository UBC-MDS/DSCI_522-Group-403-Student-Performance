import requests, zipfile, io
r = requests.get("https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip")
z = zipfile.ZipFile(io.BytesIO(r.content))

# Assume run cmd line from project repo root. 
z.extractall("./data/")