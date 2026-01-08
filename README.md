# fabric-d

Start / stop / use a containerized instance of fabric.

This repository contains 3 scripts:

- fabric-d.sh -- runs a `fabric` command in a container
- start-fabric-d.sh -- starts the `fabric-server` container in the background, with the fabric API exposed locally on port 8080. It's set to always run unless you explicitly stop it. That way it survives restarts (I kept forgetting to start it after installing new macOS beta versions.)
- stop-fabric-d.sh -- stops the fabric-server container. It''ll clean up if the server doesn't remove itself.

I wrote these to make it easier to use fabric with LM Studio on my Mac mini by integrating it with the fabric-mcp MCP server, which I also run in Docker.

The scripts use a pre-configured image pulled from my Docker hub repository. The Dockerfile I used to build it is in the fabric-yt directory - the official base image is used, which now includes yt-dlp needed by the YouTube patterns, so I don't have to add them, so the main focus now is to add a healthcheck and run as a non-root `appuser`, for security reasons.

This can be installed via homebrew. For now, I'm using a custom tap so you can do:

```shell
brew tap jimscard/fabric
brew install jimscard/fabric/fabric-d
```

The formula downloads the latest release and symlinks the .sh files to versions in brew's bin directory that don't have the .sh on them.

Thanks to @danielmiessler, author of [fabric](https://github.com/danielmiessler/Fabric) and @ksylvan author of [fabric-mcp](https://github.com/ksylvan/fabric-mcp) for making tools I use so much that I had to try to make it easier for others to use too.
Updated 2025-01-07.
