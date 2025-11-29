# fabric-d

Start / stop / use a containerized instance of fabric.

This repository contains 3 scripts:

- fabric-d.sh -- runs a `fabric` command in a container
- start-fabric-d.sh -- starts the `fabric-server` container in the background, with the fabric API exposed locally on port 8080
- stop-fabric-d.sh -- stops the fabric-server container. It''ll clean up if the server doesn't remove itself.

I wrote these to make it easier to use fabric with LM Studio on my Mac mini by integrating it with the fabric-mcp MCP server, which I also run in Docker.

The scripts use a pre-configured image pulled from my Docker hub repository. The Dockerfile I used to build it is in the fabric-yt directory - the base image was built from the Dockerfile in the fabric repository; the fabric-yt image includes yt-dlp needed by the YouTube patterns, as well as a couple of changes, e.g., a non-root `appuser`, for security reasons.

My intention is to make it so that this can be installed via Homebrew. I'll start with a custom tap and go from there. I'll update this when I've done that. The main idea is to symbolically link the .sh files to versions in brew's bin directory that don't have the .sh on them.

Thanks to @danielmiessler, author of [fabric](https://github.com/danielmiessler/Fabric) and @ksylvan author of [fabric-mcp](https://github.com/ksylvan/fabric-mcp) for making tools I use so much that I had to try to make it easier for others to use too.
