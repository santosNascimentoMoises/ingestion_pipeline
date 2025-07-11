import json
from datetime import datetime, timezone

input_path = "dados.jsonl"
output_path = "dados_com_sdc.jsonl"
# timestamp = datetime.now(timezone.utc).isoformat()
timestamp = datetime.now(timezone.utc).timestamp()

with open(input_path, "r", encoding="utf-8") as infile, \
     open(output_path, "w", encoding="utf-8") as outfile:
    for line in infile:
        obj = json.loads(line)
        obj["sdc_extracted_at"] = timestamp
        outfile.write(json.dumps(obj, ensure_ascii=False) + "\n")

