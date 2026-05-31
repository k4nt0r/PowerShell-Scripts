function Decode-Base64File {
    param (
        [string]$InputBase64File,
        [string]$OutputFile
    )

    $base64Data = Get-Content $InputBase64File -Raw
    $decodedData = [System.Convert]::FromBase64String($base64Data)
    [System.IO.File]::WriteAllBytes($OutputFile, $decodedData)
    Write-Host "Base64 data decoded and saved to $OutputFile"
}

function Create-ZipFile {
    param (
        [string[]]$InputFiles,
        [string]$OutputZipFile
    )

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($InputFiles, $OutputZipFile)
    Write-Host "Zip file created successfully: $OutputZipFile"
}

# Provide the path to the input base64 file
$InputBase64File = "C:\path\to\base64_file.txt"

# Provide the path to save the decoded data and the zip file
$DecodedFile = "C:\path\to\decoded_file.zip"

# Decode the base64 file and save it
Decode-Base64File -InputBase64File $InputBase64File -OutputFile $DecodedFile

# Create a zip file from the decoded file
Create-ZipFile -InputFiles $DecodedFile -OutputZipFile $DecodedFile
