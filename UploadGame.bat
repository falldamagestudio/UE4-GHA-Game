@set Folder=LocallyBuiltGame
@set Version=%1

@powershell -ExecutionPolicy Bypass ". .\UploadGame.ps1; UploadGame -Folder %Folder% -Version %Version%"
