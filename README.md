
# UE4 + GitHub Actions - example game

This is a build system demonstration for UE4 games.

The game is stored in this GitHub repo. It builds using GitHub Actions (using a self-hosted runner). UE4 is pre-built and stored in a [Longtail](https://github.com/DanEngelbrecht/longtail) cloud store. Resulting builds are uploaded to the same Longtail store. [Google Cloud Platform](https://cloud.google.com/gcp) is used for VMs and storage.

## Features

The [build script for the game](.github/workflows/build.yaml) is short and to the point.

[GitHub Actions](https://github.com/falldamagestudio/UE4-GHA-Game/actions) shows build progress, and controls the worker VM.

The Longtail store deduplicates data server-side -- so having lots of near-identical builds will not use a lot of space server-side. Also, downloading near-identical builds works like downloading patches in Steam.

## Major future developments

It should be easier to create the agent VM. It needs a lot of commands today.

It should be easier to build an UE4 version. In fact, there should probably be a separate project like this for building UE4 itself.

It should be easier to set up the entire environment. Think `terraform apply`, and then go.

# License

The license for this example game is available in [LICENSE.txt](LICENSE.txt). See [FetchPrebuiltUE4](https://github.com/falldamagestudio/FetchPrebuiltUE4) for licenses of the software it depends on.