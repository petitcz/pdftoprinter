param(
    [Parameter(mandatory=$true)]
    [string] $path,
    [Parameter(mandatory=$true)]
    [string] $printer
)

# --------------------------------------------------------------------------------------------
# check folder on PDF files and send then to printer
# version 0.1
# author info@codeclimber
# --------------------------------------------------------------------------------------------
# example how to use: .\foldertoprinter.ps1 -path 'C:\_temp\pdf\' -printer 'OneNote (Desktop)'
# --------------------------------------------------------------------------------------------



$adobeStart = 'C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe'

function Write-Enter
{
    Write-Output("")
}

function Write-Line()
{
    Write-Output("---------------------------------------");
}


function Check-Folder()
{

  $workpath = ($path + "/_work")
  if(!(test-path -PathType container $workpath))
  {
    Write-Output("Work folder does not exist. Creating ...")   
    New-Item -ItemType Directory -Path $workpath | Out-Null
  }


  $files = Get-ChildItem $path -Filter '*.pdf'  

  foreach($file in $files)
  {

    Write-Output("File  found: " + $file.Fullname)    
    Write-Output("Moving into working directory")        
    
    Move-Item -Path $file.Fullname -Destination ($workpath) -Force

    $fileToPrint = ($workpath + "/" + $file.Name)

    $args = "/T " + ("""$fileToPrint""" + " " + """$printer""")

    $process = Start-Process $adobeStart -ArgumentList  $args -Passthru
    Write-Host("Process started: " + $process)
    Write-Host("with arguments: " + $args)

    sleep 5;
    
    try 
    {
      Stop-Process -InputObject $process
    }
    catch
    {
      Write-Host("Process was not killed.")
    }

  }

}



# ----------------------------------------------------------
# MAIN
# ----------------------------------------------------------


Write-Line;
Write-Output("Script started. Hello.")
Write-Line;

Write-Output("Watcher started on Folder: " + $path)
Write-Output("Waiting ....")
Write-Enter;

while ($true) {
  
    sleep 5;
    Check-Folder;

}

Write-Enter;
Write-Line;
Write-Output("Script done. Bye.")
Write-Line;