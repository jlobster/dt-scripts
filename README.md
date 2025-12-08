# DEVONthink AppleScript Utilities

A collection of AppleScript utilities for automating tasks in DEVONthink 3 and DEVONthink 4.

## Scripts

### 1. PDF Metadata Updater

**Location:** `DT3-pdf-metadate/Set Created:Modified from PDF Metadata.scpt`

Updates DEVONthink entries with PDF metadata dates. Sometimes PDFs are imported with only Finder metadata instead of the actual document creation/modification dates embedded in the PDF.

**Note:** This functionality is now built into DEVONthink 4 as an official feature: Settings > Files > Import > Dates: ✅ Use content creation & modification dates. For DEVONthink 3, it was available as a hidden preference (see the folder's README for details).

**Features:**
- Extracts CreateDate and ModifyDate from PDF metadata using exiftool
- Updates DEVONthink record creation and modification dates
- Removes predefined tags (e.g., "SameDay") after successful updates
- Reports errors for any PDFs that fail processing

**Requirements:**
- exiftool installed via homebrew: `brew install exiftool`
- Script assumes exiftool is at `/opt/homebrew/bin/exiftool`

**Installation:**
1. Install exiftool: `brew install exiftool`
2. Copy the script to: `~/Library/Application Scripts/com.devon-technologies.think3/Menu`
   - Or place it in a subdirectory for organization

**Usage:**
1. Select the PDFs you want to update in your DEVONthink library
2. Run the script from the AppleScript menu (script icon) in DEVONthink
3. The script will process each PDF and display results

### 2. Database Structure Exporter

**Location:** `export-dtbase/Export dtbase Structure.scpt`

Exports the complete hierarchical structure of a DEVONthink database to a text file, providing a comprehensive overview of your database organization.

**Features:**
- Recursively exports entire database structure with proper indentation
- Distinguishes between regular groups, group tags, and replicants
- Shows both ordinary tags and group-tags for documents
- Displays parent locations for replicated documents
- Shows first 5 items per folder as samples
- Automatically excludes Trash, Tags structure, and ImageArchive folders

**Output Format:**
```
=   Folder Name (X items)            = Regular group/folder
≤   Folder Name (X items)            = Group tag
  "  Document Name                   = Regular document
  "  Document [tags: x, y]           = Document with ordinary tags
  "  Document [group-tags: x]        = Document with group-tags
  "  Document – REPLICANT            = Same document in multiple locations
      !  /path/to/location           = Parent group location
      !  /path/to/location ≤         = Parent is a group tag
```

**Installation:**
1. Copy the script to: `~/Library/Application Scripts/com.devon-technologies.think3/Menu`

**Usage:**
1. Open the DEVONthink database you want to export
2. Run the script from the AppleScript menu in DEVONthink
3. The script exports to: `{database-name}-structure.txt` in the same folder as your database
4. A notification will show when the export is complete

## System Requirements

- macOS with AppleScript support
- DEVONthink 3 or DEVONthink 4
- exiftool (for PDF metadata script only)

## Installation Notes

### Installing Scripts in DEVONthink

Scripts placed in `~/Library/Application Scripts/com.devon-technologies.think3/Menu` (or subdirectories) will appear in DEVONthink's AppleScript menu, represented by a script icon in the toolbar.

### Editing Scripts

AppleScript files (.scpt) are compiled binaries. To edit them:
1. Open with Script Editor.app on macOS
2. Make your changes
3. Save and test within Script Editor or DEVONthink

## Known Issues

### PDF Metadata Script
- The exiftool path is hardcoded to `/opt/homebrew/bin/exiftool`
- If you have homebrew installed in a different location, you'll need to modify the script

## License

This repository contains utilities for personal and educational use with DEVONthink.

## Contributing

Feel free to open issues or submit pull requests with improvements or bug fixes.
