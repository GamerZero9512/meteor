# Replace text in filenames (case-insensitive)
function SearchAndReplace($search, $replace) {
    if (-not $search) {
        [System.Windows.MessageBox]::Show("Search cannot be empty.", "meteorRename")
        return
    }

    $count = 0
    Get-ChildItem -File | ForEach-Object {
        $newName = $_.Name -replace [regex]::Escape($search), $replace
        if ($newName -ne $_.Name) {
            Rename-Item $_.FullName $newName -ErrorAction SilentlyContinue
            $count++
        }
    }

    [System.Windows.MessageBox]::Show("Renamed $count files.", "meteorRename")
}

# Add prefix
function AddPrefix($prefix) {
    if (-not $prefix) {
        [System.Windows.MessageBox]::Show("Prefix cannot be empty.", "meteorRename")
        return
    }

    $count = 0
    Get-ChildItem -File | ForEach-Object {
        $newName = "$prefix$($_.Name)"
        Rename-Item $_.FullName $newName -ErrorAction SilentlyContinue
        $count++
    }

    [System.Windows.MessageBox]::Show("Renamed $count files.", "meteorRename")
}

# Add suffix
function AddSuffix($suffix) {
    if (-not $suffix) {
        [System.Windows.MessageBox]::Show("Suffix cannot be empty.", "meteorRename")
        return
    }

    $count = 0
    Get-ChildItem -File | ForEach-Object {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $ext = $_.Extension
        $newName = "$name$suffix$ext"
        Rename-Item $_.FullName $newName -ErrorAction SilentlyContinue
        $count++
    }

    [System.Windows.MessageBox]::Show("Renamed $count files.", "meteorRename")
}

# Rename and number
function RenameAndNumber($basename, $startNum, $padding) {
    if (-not $basename) {
        [System.Windows.MessageBox]::Show("Name cannot be empty.", "meteorRename")
        return
    }

    $startNum = [int]$startNum
    $padding = [int]$padding
    $count = 0

    Get-ChildItem -File | Sort-Object Name | ForEach-Object {
        $num = $startNum + $count
        $numStr = $num.ToString("D$padding")
        $ext = $_.Extension
        $newName = "$basename$numStr$ext"
        Rename-Item $_.FullName $newName -ErrorAction SilentlyContinue
        $count++
    }

    [System.Windows.MessageBox]::Show("Renamed $count files.", "meteorRename")
}

# Lowercase all filenames
function LowercaseAll {
    $count = 0
    Get-ChildItem -File | ForEach-Object {
        $newName = $_.Name.ToLower()
        if ($newName -cne $_.Name) {
            Rename-Item $_.FullName $newName -ErrorAction SilentlyContinue
            $count++
        }
    }

    if ($count -eq 0) {
        [System.Windows.MessageBox]::Show("No files to convert.", "meteorRename")
    } else {
        [System.Windows.MessageBox]::Show("Renamed $count files.", "meteorRename")
    }
}