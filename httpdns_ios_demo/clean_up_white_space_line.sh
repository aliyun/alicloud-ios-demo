#!/bin/bash

# Find all Objective-C and Swift files in the current directory and subdirectories
find . -name "*.m" -o -name "*.h" -o -name "*.swift" | while read file; do
    echo "Processing $file"
    # Use sed to strip all whitespace-only lines, excluding lines ending with a backslash
    sed -i '' '/^[[:space:]]*$/{
        /\\$/!s/^[[:space:]]*$//
    }' "$file"
done

echo "Whitespace cleaning complete."

