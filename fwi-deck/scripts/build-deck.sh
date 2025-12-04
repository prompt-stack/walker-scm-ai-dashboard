#!/bin/bash
# Build FWI Deck - Combines individual slides into single HTML for export

OUTPUT_FILE="../fwi-deck-combined.html"
SLIDES_DIR="."

echo "Building FWI deck..."

# Start the HTML file
cat > "$OUTPUT_FILE" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Frictionless Workforce Initiative - Walker SCM 2026</title>
    <style>
HEADER

# Include the CSS
cat slide-styles.css >> "$OUTPUT_FILE"

# Close style and add container
cat >> "$OUTPUT_FILE" << 'MIDDLE'

        .artboards-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
            padding: 20px;
        }

        .artboard {
            width: 16in;
            height: 9in;
            overflow: hidden;
            position: relative;
            background: white;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            page-break-after: always;
            page-break-inside: avoid;
        }

        @media print {
            .artboards-container { padding: 0; gap: 0; }
            .artboard {
                box-shadow: none;
                margin: 0;
            }
        }
    </style>
</head>
<body>
    <div class="artboards-container">
MIDDLE

# Process each slide in order
for i in $(seq -w 1 52); do
    SLIDE_FILE=$(ls ${i}-*.html 2>/dev/null | head -1)
    if [ -f "$SLIDE_FILE" ]; then
        echo "  Adding: $SLIDE_FILE"
        # Extract body content and wrap in artboard div
        echo "        <!-- Slide $i -->" >> "$OUTPUT_FILE"
        echo "        <div class=\"artboard\">" >> "$OUTPUT_FILE"
        # Extract content between <body> and </body>, excluding the tags
        sed -n '/<body>/,/<\/body>/p' "$SLIDE_FILE" | sed '1d;$d' >> "$OUTPUT_FILE"
        echo "        </div>" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    fi
done

# Close the HTML
cat >> "$OUTPUT_FILE" << 'FOOTER'
    </div>
</body>
</html>
FOOTER

echo "Done! Output: $OUTPUT_FILE"
echo "Slide count: $(grep -c '<div class="artboard">' "$OUTPUT_FILE")"
