import csv

organisms = dict()

with open("../../experimentA/idr0157-experimentA-annotation.csv", mode="r", encoding='utf-8-sig') as csvfile:
    reader = csv.DictReader(csvfile, delimiter=",")
    for row in reader:
        key = f"{row['Dataset Name']}|{row['Image Name']}"
        organisms[key] = f"NCBI:txid{row['Term Source 1 Accession']}"

for key, value in organisms.items():
    print(f"{key}|{value}")
