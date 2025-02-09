# winImageSorting

parse all files with format (jpeg, jpg, png) in the current script folder and create subfolders based on available date inside metadata (YYYY-MM) and copy images to them.

subFolder format are "YYYY-MM" (ex: 2025-02)

Date properties used are selected in that order: 
1. metadata date Taken (metadata property name: PropertyTagExifDTOrig)
2. metadata digitalize date (metadata property name: PropertyTagExifDTDigitized)
3. metadata creation date (metadata property name: PropertyTagDateTime)
4. last modification date (file property name: LastWriteTime)

#### why copy instead of move ?
to keep the control of my pictures, if the folders or the sorting isn't correct with what I expected, i just need to delete all the created folder and update the script.


