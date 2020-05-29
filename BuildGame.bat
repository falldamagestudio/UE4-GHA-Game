@set ProjectLocation=ExampleGame\ExampleGame.uproject
@set TargetPlatform=Win64
@set Configuration=Development
@set Target=ExampleGame
@set ArchiveDir=LocallyBuiltGame

@if not exist %ArchiveDir% md %ArchiveDir%
@powershell -ExecutionPolicy Bypass ". .\BuildGame.ps1; BuildGame -ProjectLocation %ProjectLocation% -TargetPlatform %TargetPlatform% -Configuration %Configuration% -Target %Target% -ArchiveDir %ArchiveDir%"


