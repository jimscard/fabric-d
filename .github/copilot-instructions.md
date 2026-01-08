# Copilot Instructions for fabric-d

## Project Overview

This repository provides containerized wrapper scripts for the [fabric](https://github.com/danielmiessler/Fabric) tool. The scripts make it easier to run fabric commands in Docker containers without installing fabric directly on the host system.

## Core Components

### Shell Scripts
- **fabric-d.sh**: Runs one-off fabric commands in a Docker container
- **start-fabric-d.sh**: Starts fabric-server in detached mode with auto-restart
- **stop-fabric-d.sh**: Stops and removes the fabric-server container
- **release-fabric-d-auto.sh**: Automated release script using GitHub CLI

### Docker Image
- Uses `kayvan/fabric:latest` Docker image
- Exposes port 8080 for the fabric server

### Configuration
- User configuration is stored in `$HOME/.fabric-config`
- This directory is mounted to `/home/appuser/.config/fabric` in containers
- Scripts check for this directory and create it if missing

## Coding Conventions

### Shell Scripting
- Use bash (#!/bin/bash) for all scripts
- Include descriptive comments at the top of each script
- Use `set -euo pipefail` in automation scripts for error handling
- Check for required commands and directories before execution
- Provide clear error messages with echo to stderr
- Use double quotes around variables (`"$VAR"`) to prevent word splitting
- Prefer `[[ ]]` over `[ ]` for conditional tests
- Exit with non-zero status codes on errors

### Docker Usage
- Always use `--rm` flag for one-off commands to auto-cleanup
- Use `-it` for interactive commands
- Map port 8080 consistently: `-p 8080:8080`
- Volume mount pattern: `-v "$HOME/.fabric-config:/home/appuser/.config/fabric"`
- Use `--name fabric-server` for the persistent server container
- Use `--restart unless-stopped` for the server to ensure availability

### Error Handling
- Check exit codes with `$?` or use command chaining (`&&`, `||`)
- Provide user-friendly error messages
- Exit cleanly with appropriate status codes (0 for success, 1+ for errors)

## Release Process

- Releases are automated via GitHub Actions workflow
- Version format: `vMAJOR.MINOR.PATCH` (e.g., v1.2.1)
- Auto-increments patch version by default
- Creates git tags and GitHub releases with source archives
- Uses GitHub CLI (`gh`) for release creation

## Testing

- Manual testing is required for script changes
- Test with and without existing configuration directories
- Verify Docker container startup, execution, and cleanup
- Check port availability (8080)

## Dependencies

- Docker (required for all scripts)
- Git (for version control and releases)
- GitHub CLI (for automated releases)
- yt-dlp (included in Docker image)

## Future Plans

- Homebrew installation via custom tap
- Symbolic links in brew's bin directory without .sh extensions
