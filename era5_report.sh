#!/bin/bash

# ERA5 Climate Data Report Generator
# Usage: ./era5_report.sh [directory]
# If no directory is provided, uses current directory

# Set the base directory (default to current directory if not provided)
BASE_DIR="${1:-.}"

# Check if directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Directory '$BASE_DIR' does not exist"
    exit 1
fi

echo "========================================="
echo "ERA5 Climate Data Report"
echo "========================================="
echo "Base Directory: $BASE_DIR"
echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="
echo ""

# Find all subdirectories that contain .nc files
for var_dir in "$BASE_DIR"/*; do
    # Skip if not a directory
    [ ! -d "$var_dir" ] && continue

    # Get variable name from directory
    var_name=$(basename "$var_dir")

    # Count .nc files in this directory
    file_count=$(find "$var_dir" -maxdepth 1 -name "*.nc" -type f 2>/dev/null | wc -l)

    # Skip if no .nc files found
    [ "$file_count" -eq 0 ] && continue

    # Get directory size
    dir_size=$(du -sh "$var_dir" 2>/dev/null | cut -f1)

    # Extract date ranges from filenames
    # Pattern: YYYYMMDDHHMI-YYYYMMDDHHMI.nc
    dates=$(find "$var_dir" -maxdepth 1 -name "*.nc" -type f -exec basename {} \; 2>/dev/null | \
            grep -oE '[0-9]{12}-[0-9]{12}' | sort)

    if [ -n "$dates" ]; then
        # Get first and last date ranges
        first_date=$(echo "$dates" | head -1 | cut -d'-' -f1)
        last_date=$(echo "$dates" | tail -1 | cut -d'-' -f2)

        # Format dates for readability
        start_date=$(echo "$first_date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5/')
        end_date=$(echo "$last_date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5/')
        date_range="$start_date to $end_date"
    else
        date_range="N/A"
    fi

    # Print report for this variable
    echo "Model: ERA5"
    echo "Variable: $var_name"
    echo "Number of files: $file_count"
    echo "Range: $date_range"
    echo "Size of variable directory: $dir_size"
    echo "-----------------------------------------"
    echo ""
done

# Summary statistics
total_files=$(find "$BASE_DIR" -name "*.nc" -type f 2>/dev/null | wc -l)
total_size=$(du -sh "$BASE_DIR" 2>/dev/null | cut -f1)

echo "========================================="
echo "Summary"
echo "========================================="
echo "Total .nc files: $total_files"
echo "Total size: $total_size"
echo "========================================="
