cd FetchPrebuiltUE4
.\FetchPrebuiltUE4 update-local-ue4-version
if ($LASTEXITCODE -ne 0) { throw }
