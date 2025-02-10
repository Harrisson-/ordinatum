[reflection.assembly]::LoadWithPartialName("System.Drawing")

# 36867 date Taken (PropertyTagExifDTOrig)
# 36868 PropertyTagExifDTDigitized
# 306 creation date (PropertyTagDateTime)
# 800 file title (PropertyTagImageTitle)
$metadataCodes = @(36867, 36868, 306, 800);

# hastable where key = folderName; value = fileName
$sortFiles = [ordered]@{};

# file with issues
$issues = @();


function parseDate {
  param (
    $picDate
  )

    $strYear = [String][Char]$picDate[0]+[String][Char]$picDate[1]+[String][Char]$picDate[2]+[String][Char]$picDate[3]
    $strMonth = [String][Char]$picDate[5]+[String][Char]$picDate[6]
    $strDay = [String][Char]$picDate[8]+[String][Char]$picDate[9]
    return $strYear + "-" + $strMonth;
}

$test = Get-ChildItem -path ./* -Include ('*.jpg', '*.png', '*.jpeg' ) | ForEach-Object {
  $folderName;
  $fileInformations = Get-ItemProperty -Path $_ ;
  $pic = [System.Drawing.Bitmap]::FromFile(($_.FullName));

  if ([bool]$pic.PropertyIdList.Contains($metadataCodes[0])) {
    $picDate = $pic.GetPropertyItem($metadataCodes[0]).value[0..9];
    $folderName = parseDate($picDate);
  } ElseIf ([bool]$pic.PropertyIdList.Contains($metadataCodes[1])) {
    $picDate = $pic.GetPropertyItem($metadataCodes[1]).value[0..9];
    $folderName = parseDate($picDate);
  } ElseIf ([bool]$pic.PropertyIdList.Contains($metadataCodes[2])) {
    $picDate = $pic.GetPropertyItem($metadataCodes[2]).value[0..9];
    $folderName = parseDate($picDate);
  } ElseIf ([bool]$_.LastWriteTime) {
    $date = $_.LastWriteTime | Get-Date -Format "yyyy-MM-dd"
    $folderName = parseDate($date);
  } else {
    $issues += "$($_.Name)";
  }

  if ([bool]$sortFiles.Contains($folderName)) {
    $sortFiles[$folderName] += $_;
  } else {
    $sortFiles.Add($folderName, @($_));
  }
}

foreach ($folder in $sortFiles.Keys) {
  $Destionation = New-Item -Path . -Name ($folder) -ItemType Directory -Force

  foreach ($file in $sortFiles[$folder]) {
    Copy-Item -Path ($file.FullName) -Destination $Destionation.FullName
  }
}

$issues | Out-File -Append .\issues.txt
