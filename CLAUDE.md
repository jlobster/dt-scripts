# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains AppleScript utilities for DEVONthink 3 (and DEVONthink 4). These scripts automate tasks within DEVONthink, a document management application for macOS.

## Project Structure

- `DT3-pdf-metadate/` - Script to update PDF metadata in DEVONthink entries
  - Uses exiftool to extract PDF creation/modification dates and updates DEVONthink records
  - Requires exiftool installed via homebrew at `/opt/homebrew/bin/exiftool`
  - Script file: `Set Created:Modified from PDF Metadata.scpt`

- `export-dtbase/` - Script to export DEVONthink database structure
  - Exports hierarchical database structure to text file
  - Shows groups, documents, tags, group-tags, and replicants
  - Script file: `Export dtbase Structure.scpt`

## Script Architecture

### PDF Metadata Script

Key functionality:
- Iterates through selected PDFs in DEVONthink
- Uses exiftool shell commands to extract CreateDate and ModifyDate from PDF metadata
- Updates DEVONthink record properties (creation date, modification date)
- Removes predefined tags (e.g., "SameDay") after successful metadata updates
- Tracks errors for files that fail processing
- Uses the `make_date` handler to convert date strings to date objects

Important notes:
- Script assumes exiftool is at `/opt/homebrew/bin/exiftool` (hardcoded path)
- Works with DEVONthink's AppleScript dictionary: `DTcr` (creation date), `DTmo` (modification date), `DTty` (type), `DTsl` (selection)
- Error handling for both CreateDate and ModifyDate extraction

### Database Export Script

Key functionality:
- Recursively processes DEVONthink database groups and records
- Main handler: `processGroup(theGroup, indentLevel)` - recursively walks the database structure
- Helper handler: `joinList(theList, delimiter)` - joins list items with a delimiter
- Distinguishes between:
  - Regular groups (folders) - marked with =
  - Group tags - marked with ≤ (acts as both group and tag)
  - Regular documents
  - Replicants (documents in multiple locations)
  - Ordinary tags vs group-tags
- Outputs structured text with indentation showing hierarchy
- Excludes: Trash, Tags structure, and ImageArchive folders
- Shows first 5 items per folder as samples

Important notes:
- Writes output to `{database-name}-structure.txt` in the same folder as the database
- Uses DEVONthink properties: `DTch` (children), `DTpr` (parents), `DTtt` (tag type), `DTro` (root)
- Tag types: `Ttypotag` (ordinary tag), `Ttypgtag` (group tag)

## Testing Scripts

AppleScripts (.scpt files) are compiled binaries and should be edited in Script Editor on macOS:
- Open files with Script Editor.app
- Test by running within Script Editor or installing in DEVONthink's script menu
- Install location: `~/Library/Application Scripts/com.devon-technologies.think3/Menu`

## Dependencies

- exiftool: Install via `brew install exiftool`
- DEVONthink 3 or DEVONthink 4 application
- macOS with AppleScript support

## DEVONthink AppleScript Dictionary Reference

Common properties used across scripts:
- `pnam` - name property
- `ppth` - POSIX path
- `type` - record type (DtypDTgr for groups, OCRdpdf for PDFs)
- `tags` - tags list
- `strq` - quoted form of string (for shell safety)
