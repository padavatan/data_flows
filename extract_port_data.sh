#!/bin/bash

# Define input path
input_dir="/home/jpadavatan/lustre/ccam_install_20240215/src/run_ACCESS_8km_saws/post_points/benjy"

# Define variables to process
variables=("u10" "d10")

# Define locations with coordinates (lon/lat)
declare -A locations
locations["saldanha"]="17.918068/-33.084923"
locations["capetown"]="18.303854/-33.843876"
locations["mossel"]="22.268625/-34.337446"
locations["ngqura"]="25.950827/-33.94977"
locations["eastlondon"]="27.950933/-33.060892"
locations["durban"]="31.118288/-29.874164"
locations["richards"]="32.12997/-28.908597"

# Process each variable
for var in "${variables[@]}"; do
    echo "Processing $var files..."
    var_ports_dir="$input_dir/$var/ports"
    [ ! -d "$var_ports_dir" ] && mkdir -p "$var_ports_dir"
    
    for file in "$input_dir"/$var/*.nc; do
        filename=$(basename "$file")
        
        # Extract for each location
        for city in "${!locations[@]}"; do
            outfile="${filename%.nc}_${city}.nc"
            echo "Extracting $city from $filename"
            cdo remapnn,lon=${locations[$city]%/*}/lat=${locations[$city]#*/} "$file" "${var_ports_dir}/${outfile}"
        done
    done
    
    echo "$var port data saved to: $var_ports_dir"
done

echo "Done!"
echo "All variables processed successfully!"