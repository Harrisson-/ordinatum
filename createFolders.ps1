[reflection.assembly]::LoadWithPartialName("System.Drawing");
$dates = [System.Collections.ArrayList]::new()

$test = Get-ChildItem -path ./* -Include *.jpg | ForEach-Object {
  $imagePath = "./" + $_.Name
  $pic= New-Object System.Drawing.Bitmap $imagePath

  $picDate = $pic.GetPropertyItem(36867).value[0..9]

  $strYear = [String][Char]$picdate[0]+[String][Char]$picdate[1]+[String][Char]$picdate[2]+[String][Char]$picdate[3]
  $strMonth = [String][Char]$picdate[5]+[String][Char]$picdate[6]
  $strDay = [String][Char]$picdate[8]+[String][Char]$picdate[9]
  $dates.Add($strYear + "-" + $strMonth)
}
$dates = $dates | select -Unique
$dates

foreach ($date in $dates) {
  New-Item -Path . -Name ($date) -ItemType Directory
}
