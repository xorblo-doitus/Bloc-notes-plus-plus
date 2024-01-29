import csv

cleaned = []

with open("src/assets/translations/translations.csv", "r", encoding="utf-8", newline="") as file:
	reader = csv.reader(file)
	
	first_line = next(reader)
	
	to_crop = 0
	for header in first_line[::-1]:
		if header == "":
			to_crop += 1
		else:
			break
	
	if to_crop > 0:
		for row in [first_line] + list(reader):
			cleaned.append(row[:-to_crop])
	else:
		cleaned = None

if not cleaned is None:
	with open("src/assets/translations/translations.csv", "w", encoding="utf-8", newline="") as file:
		writer = csv.writer(file)
		# for row in cleaned:
		writer.writerows(cleaned)
		# for i, row in enumerate(cleaned):
		# 	if row.endswith("\n"):
		# 		continue
		# 	cleaned[i] += "\n"
		# file.writelines(cleaned)