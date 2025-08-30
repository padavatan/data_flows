#!/bin/bash

# Define input path
input_dir="/home/jpadavatan/lustre/ccam_install_20240215/src/run_ACCESS_8km_saws/post_points/benjy"

# Define locations with coordinates (lon/lat)
declare -A locations
locations["saldanha"]="17.918068/-33.084923"
locations["capetown"]="18.303854/-33.843876"
locations["mossel"]="22.268625/-34.337446"
locations["ngqura"]="25.950827/-33.94977"
locations["eastlondon"]="27.950933/-33.060892"
locations["durban"]="31.118288/-29.874164"
locations["richards"]="32.12997/-28.908597"

# Process u10 files
echo "Processing u10 files..."
u10_ports_dir="$input_dir/u10/ports"
[ ! -d "$u10_ports_dir" ] && mkdir -p "$u10_ports_dir"

for file in "$input_dir"/u10/*.nc; do
    filename=$(basename "$file")
    
    # Extract for each location
    for city in "${!locations[@]}"; do
        outfile1="${filename%.nc}_${city}.nc"
        echo "Extracting $city from $filename"
        cdo remapnn,lon=${locations[$city]%/*}/lat=${locations[$city]#*/} "$file" "${u10_ports_dir}/${outfile1}"
    done
done

# Process d10 files  
echo "Processing d10 files..."
d10_ports_dir="$input_dir/d10/ports"
[ ! -d "$d10_ports_dir" ] && mkdir -p "$d10_ports_dir"

for file in "$input_dir"/d10/*.nc; do
    filename=$(basename "$file")
    
    # Extract for each location
    for city in "${!locations[@]}"; do
        outfile1="${filename%.nc}_${city}.nc"
        echo "Extracting $city from $filename"
        cdo remapnn,lon=${locations[$city]%/*}/lat=${locations[$city]#*/} "$file" "${d10_ports_dir}/${outfile1}"
    done
done

echo "Done!"
echo "U10 port data saved to: $u10_ports_dir"
echo "D10 port data saved to: $d10_ports_dir"