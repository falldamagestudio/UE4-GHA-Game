
# UE4 + GitHub Actions - example game

This is a build system demonstration for UE4 games.

The game is stored in this GitHub repo. It builds using GitHub Actions (using a self-hosted runner). UE4 is pre-built and stored in a [Longtail](https://github.com/DanEngelbrecht/longtail) cloud store. Resulting builds are uploaded to the same Longtail store. [Google Cloud Platform](https://cloud.google.com/gcp) is used for VMs and storage.

See [UE4-GHA-Engine](https://github.com/falldamagestudio/UE4-GHA-Engine) for the engine builds, and [UE4-GHA-BuildSystem](https://github.com/falldamagestudio/UE4-GHA-BuildSystem) for the build system itself.

## Features

The [build script for the game](.github/workflows/build.yaml) is short and to the point.

You can follow the build process via [GitHub Actions](https://github.com/falldamagestudio/UE4-GHA-Engine/actions).

The self-hosted runner VM allows for incremental builds.

The VM is only running when a build is in progress. Therefore, it only incurs vCPU/RAM cost during the builds. (The VM disk incurs cost even when the VM is stopped.)

The Longtail store deduplicates data server-side -- so having lots of near-identical builds will not use a lot of space server-side. Also, downloading near-identical builds works like downloading patches in Steam.

## Repository name constraints

If you clone this to your own repository, you must pick a short name. GitHub Actions + the repo structure will place UE4 at `C:\A\_work\<reponame>\<reponame>\UE4` on the runner machine - and this path must be less than 50 characters long.

# License

The license for this example game is available in [LICENSE.txt](LICENSE.txt). See [golongtail](https://github.com/DanEngelbrecht/golongtail) and [FetchPrebuiltUE4](https://github.com/falldamagestudio/FetchPrebuiltUE4) for licenses of the software it depends on.
