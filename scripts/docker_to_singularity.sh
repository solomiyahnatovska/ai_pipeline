#!/bin/bash

# Directory containing WDL files
WDL_DIR="/scratch/hnatovs1/ai_pipeline/gatk4-germline-snps-indels"

# Backup existing WDL files (optional but recommended)
echo "Backing up original WDL files..."
find "$WDL_DIR" -name '*.wdl' -exec cp {} {}.bak \;

# Update all WDL files
echo "Updating WDL files..."
find "$WDL_DIR" -name '*.wdl' | while read -r file; do
    echo "Updating $file..."

    # Replace `docker: container` with `container: "~{container}"`
    sed -i -E 's/docker:[[:space:]]*"~\{([^}]+)\}"/container: "~{\1}"/g' "$file"

done

echo "✅ All WDL files updated successfully!"
