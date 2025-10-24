#!/bin/bash

WDL_DIR="/scratch/aujlana/gatk_sv_v.1.0.2/wdl"
cd "$WDL_DIR" || exit 1

for file in *.wdl; do
  echo "Processing $file..."

  # Backup original
  cp "$file" "${file}.bak"

  awk '
    BEGIN { inside = 0 }

    /^\s*runtime\s*\{/ { inside = 1 }
    inside && /^\s*\}/ { inside = 0 }

    {
      orig = $0

      if (inside && /^\s*memory:\s*/ && $0 !~ /"~?\{.*\} GB"/) {
        # Remove any trailing comments
        gsub(/\/\/.*/, "")

        # Trim leading/trailing spaces
        sub(/^[ \t]*/, "", $0)
        sub(/[ \t]*$/, "", $0)

        # Handle numeric values: memory: 4
        if ($0 ~ /^memory:\s*[0-9.]+$/) {
          sub(/^memory:\s*/, "memory: \"")
          $0 = $0 " GB\""
        }
        # Handle simple variables: memory: mem_gb
        else if ($0 ~ /^memory:\s*[a-zA-Z0-9_]+$/) {
          var = gensub(/^memory:\s*([a-zA-Z0-9_]+)$/, "\\1", "g", $0)
          $0 = "memory: \"~{" var "} GB\""
        }
        # Handle expressions: memory: select_first(...)
        else if ($0 ~ /^memory:\s*select_first\(/) {
          expr = gensub(/^memory:\s*(.*)/, "\\1", "g", $0)
          $0 = "memory: \"~{" expr "} GB\""
        }
      }

      print
    }
  ' "$file" > "${file}.tmp"

  # Replace original with fixed version
  mv "${file}.tmp" "$file"

  # Final cleanup: trim inside ~{...}
  sed -E -i 's/~\{ *([^} ]*[^ }]*) *\}/~{\1}/g' "$file"
  sed -E -i 's/"?[ ]*GiB[ ]*"?/" GB"/g' "$file"                 # GiB → GB (with or without quotes)
done

echo "✔ All files processed. Backups saved as *.bak"