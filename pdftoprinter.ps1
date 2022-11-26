param(
    [Parameter(mandatory=$true)]
    [string] $path,
    [Parameter(mandatory=$true)]
    [string] $printer
)

# --------------------------------
# check folder and send to print
# version 0.1
# author info@codeclimber
# --------------------------------



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

        
    Write-Output("Moving into working directory")        

    Write-Output("File  found: " + $file.Fullname)

    Move-Item -Path $file.Fullname -Destination ($workpath)
        
    $args = "/T " + ($workpath + "/" + $file.Name + " " + $printer)

    Start-Process $adobeStart -ArgumentList  $args
   
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