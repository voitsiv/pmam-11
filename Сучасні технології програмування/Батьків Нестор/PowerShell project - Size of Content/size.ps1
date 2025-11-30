$folderPath = Get-Location

$items = Get-ChildItem -Force $folderPath |
    Select-Object FullName, @{
        Name='Size'
        Expression={
            if ($_.PSIsContainer) {
                Get-ChildItem $_.FullName -Recurse | Measure-Object -Property Length -Sum | Select-Object -ExpandProperty Sum
            } else {
                $_.Length
            }
        }
    } |
    Sort-Object -Property Size -Descending

function Format-Size {
    param($size)

    $suffixes = "B", "KB", "MB", "GB", "TB"

    $index = 0
    while ($size -ge 1KB -and $index -lt $suffixes.Length) {
        $size /= 1KB
        $index++
    }

    "{0:N2} {1}" -f $size, $suffixes[$index]
}

$items | ForEach-Object {
    $formattedSize = Format-Size $_.Size
    Write-Output ("{0,-100} {1}" -f $_.FullName, $formattedSize)
}