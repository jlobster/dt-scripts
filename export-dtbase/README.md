# DEVONthink Database Structure Exporter

An AppleScript that exports the complete hierarchical structure of a DEVONthink database to a text file, providing a comprehensive map of your database organization.

## Testing Status

**This script has only been tested on DEVONthink 4.** While it may work with DEVONthink 3, compatibility has not been verified.

## What It Does

This script recursively walks through your entire DEVONthink database and creates a text file that shows:

- **All groups and folders** with their hierarchy (proper indentation)
- **Group tags** - special groups that act as both folders and tags
- **Documents** with their associated tags
- **Replicants** - documents that exist in multiple locations
- **Parent locations** for replicated documents

The output provides a bird's-eye view of your database structure, making it easy to understand organization patterns, find replicants, and audit your database layout.

## Features

### Smart Classification

The script distinguishes between:
- **Regular groups** (folders) - marked with `=`
- **Group tags** - marked with `≤` (acts as both a group and a tag)
- **Regular documents** - shown with `"`
- **Documents with tags** - displays both ordinary tags and group-tags separately
- **Replicants** - documents in multiple locations, marked as `– REPLICANT`

### Intelligent Filtering

- **Automatically excludes**: Trash, Tags structure, and ImageArchive folders
- **Shows samples**: Displays first 5 items per folder to keep output manageable
- **Parent tracking**: For replicants, lists all parent locations with full paths

### Tag Separation

The script intelligently separates:
- **Ordinary tags** `[tags: x, y]` - metadata-only tags
- **Group-tags** `[group-tags: x]` - tags that also exist as groups in the database

## Output Format

The exported text file includes a legend and uses these symbols:

```
=   Folder Name (X items)              = Regular group/folder
≤   Folder Name (X items)              = Group tag (both group and tag)
  "  Document Name                     = Regular document
  "  Document [tags: x, y]             = Document with ordinary tags
  "  Document [group-tags: x]          = Document with group-tags
  "  Document – REPLICANT (N instances) = Document in multiple locations
      !  /path/to/location             = Parent group location
      !  /path/to/location ≤           = Parent is a group tag
```

## Installation

1. Copy `Export dtbase Structure.scpt` to:
   ```
   ~/Library/Application Scripts/com.devon-technologies.think3/Menu
   ```
   Or place it in a subdirectory for organization.

2. The script will appear in DEVONthink's AppleScript menu (script icon in the toolbar).

## Usage

1. **Open** the DEVONthink database you want to export
2. **Run** the script from the AppleScript menu in DEVONthink
3. The script will process the database (may take time for large databases)
4. **Output file** is created: `{database-name}-structure.txt` in the same folder as your database
5. A **notification** and dialog will confirm when the export is complete

## Example Output

```
DEVONthink Structure Export: My Research Database
Exported: Tuesday, December 3, 2024 at 10:30:45 AM

=   Research Projects (15 items)
    "  Project Proposal.pdf
    "  Meeting Notes.md [tags: urgent, review]
    =   Archive (8 items)
        "  Old Data.xlsx
        "  Report 2023.pdf – REPLICANT (2 instances)
            !  /Research Projects/Archive
            !  /Shared Documents/Reports

≤   Important (23 items)
    "  Key Document.pdf [group-tags: Important]
```

## Technical Details

### How It Works

1. **Gets current database** - Works with whichever database is active in DEVONthink
2. **Builds legend** - Creates a header with export timestamp and symbol legend
3. **Processes root groups** - Starts from database root, excluding Trash and Tags
4. **Recursively traverses** - For each group:
   - Gets group name, type, and item count
   - Identifies if it's a group tag vs regular group
   - Processes first 5 documents (with full tag analysis)
   - Detects replicants by counting non-Tag parent groups
   - Recursively processes subgroups with increased indentation
5. **Writes output file** - Creates text file in database folder with full structure

### Replicant Detection

A document is identified as a replicant if it has more than one parent group (excluding the `/Tags/` pseudo-location). For each replicant, the script lists all parent locations so you can see where the document appears in your database.

## System Requirements

- macOS with AppleScript support
- DEVONthink 4 (tested)
- DEVONthink 3 compatibility unknown

## Known Limitations

- Shows only first 5 items per folder (to keep output manageable for large databases)
- Does not show the Tags structure itself (excluded by design)
- Does not show contents of ImageArchive folders (excluded by design)
- Processing large databases may take several minutes

## Troubleshooting

**Script doesn't appear in menu:**
- Verify installation path: `~/Library/Application Scripts/com.devon-technologies.think3/Menu`
- Restart DEVONthink after installing

**Error writing file:**
- Ensure you have write permissions to the database folder
- Check that the database file is not in a protected system location

**Script runs but no output:**
- Check the same folder where your `.dtBase2` file is located
- Look for `{database-name}-structure.txt`

## Use Cases

- **Database auditing** - Review overall organization and structure
- **Finding replicants** - Identify documents that exist in multiple locations
- **Documentation** - Create a snapshot of database structure for reference
- **Planning reorganization** - Understand current structure before making changes
- **Backup metadata** - Keep a text record of database organization

## Editing the Script

To modify the script:
1. Open `Export dtbase Structure.scpt` with **Script Editor.app** on macOS
2. Make your changes
3. Save (AppleScript files are compiled binaries)
4. Test within Script Editor or DEVONthink

Possible modifications:
- Change the 5-item limit (search for `if i > 5`)
- Modify excluded folders (search for "Trash", "Tags", "ImageArchive")
- Adjust output formatting (modify the string building sections)
- Change output symbols (modify `groupIndicator` and other markers)
