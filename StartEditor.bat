@set ProjectLocation=%~dp0ExampleGame\ExampleGame.uproject
@powershell -ExecutionPolicy Bypass ". .\Scripts\Windows\Run-Editor.ps1; Run-Editor -UProjectLocation %ProjectLocation%"