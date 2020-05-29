@set ProjectLocation=ExampleGame\ExampleGame.uproject
@set TargetPlatform=Win64
@set Configuration=Development
@set Target=ExampleGame
@set ArchiveDir=BuiltGame

@md %ArchiveDir%
@powershell -ExecutionPolicy Bypass ". .\Scripts\Windows\Run-UAT.ps1; Run-UAT -UProjectLocation %ProjectLocation% -Arguments  ""-ScriptsForProject=$(Resolve-Path %ProjectLocation%)"" ""BuildCookRun"" ""-installed"" ""-nop4"" ""-project=$(Resolve-Path %ProjectLocation%)"" ""-cook"" ""-stage"" ""-archive"" ""-archivedirectory=$(Resolve-Path %ArchiveDir%)"" ""-package"" ""-pak"" ""-prereqs"" ""-nodebuginfo"" ""-targetplatform=%TargetPlatform%"" ""-build"" ""-target=%Target%"" ""-clientconfig=%Configuration%"" ""-utf8output"""
