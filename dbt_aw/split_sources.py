#!/usr/bin/env python3
"""
split_sources.py  –  Divide um YAML único (dbt generate_source) 
                     em múltiplos arquivos (um por tabela).

Uso:
    python split_sources.py tmp/bronze_all.yml models/sources/bronze


python split_sources.py models/sources/schema_bronze.yml models/sources
"""

import sys, argparse, pathlib, yaml

def main():
    parser = argparse.ArgumentParser(description="Split dbt source YAML by table.")
    parser.add_argument("input",  help="YAML monolito gerado pelo generate_source")
    parser.add_argument("output", help="Diretório onde serão criados os arquivos .yml")
    args = parser.parse_args()

    input_path  = pathlib.Path(args.input)
    output_dir  = pathlib.Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    with input_path.open() as f:
        data = yaml.safe_load(f)

    # assumimos apenas um bloco sources[0]
    source_block = data["sources"][0]
    common_head = {
        "version": data["version"],
        "sources": [
            {
                "name":     source_block["name"],
                "database": source_block.get("database"),
                "schema":   source_block.get("schema"),
                "tables":   []          # será preenchido por tabela
            }
        ]
    }

    for table in source_block["tables"]:
        tbl_name   = table["name"]
        tbl_yaml   = common_head.copy()
        tbl_yaml["sources"][0]["tables"] = [table]

        out_file = output_dir / f"schema_{tbl_name}.yml"
        with out_file.open("w") as fout:
            yaml.safe_dump(
                tbl_yaml, fout,
                sort_keys=False,            # mantém ordem natural
                default_flow_style=False
            )
        print(f"OK ➜  {out_file}")

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print(__doc__)
        sys.exit(0)
    main()
