#!/bin/bash

# Find all .env files in the workspace
find /media/rizzo/RAIDSTATION/stacks -name ".env" -type f | while read -r file; do
    echo "Processing: $file"
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    while IFS= read -r line; do
        # If line is empty or starts with #, write as is
        if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
            echo "$line" >> "$temp_file"
            continue
        fi
        
        # If line contains = and doesn't start with a quoted value
        if [[ "$line" =~ ^[A-Za-z0-9_]+= ]] && ! [[ "$line" =~ ^[A-Za-z0-9_]+=\" ]]; then
            # Get the variable name (everything before =)
            var_name=$(echo "$line" | cut -d= -f1)
            # Get the value (everything after =)
            var_value=$(echo "$line" | cut -d= -f2-)
            # Write with quotes
            echo "${var_name}=\"${var_value}\"" >> "$temp_file"
        else
            # Write line as is
            echo "$line" >> "$temp_file"
        fi
    done < "$file"
    
    # Preserve permissions and replace original
    cp -a --attributes-only "$file" "$temp_file"
    mv "$temp_file" "$file"
done

echo "All .env files have been processed."