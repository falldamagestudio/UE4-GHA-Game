@set Folder=DownloadedGame
@set Version=%1

@if not exist %Folder% md %Folder%
@powershell -ExecutionPolicy Bypass ". .\DownloadGame.ps1; DownloadGame -Folder %Folder% -Version %Version%"
