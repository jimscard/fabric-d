# Copilot Instructions for fabric-d

## Repository Overview

This repository provides Docker containerization scripts for the [Fabric](https://github.com/danielmiessler/Fabric) tool, making it easier to run Fabric in isolated containers with all necessary dependencies.

## Key Components

### Shell Scripts
- **fabric-d.sh**: One-off Fabric command execution in a container
- **start-fabric-d.sh**: Starts the Fabric server container in detached mode
- **stop-fabric-d.sh**: Stops and cleans up the Fabric server container
- **release-fabric-d-auto.sh**: Automated release and tagging script

### Docker Image
- Based on `kayvan/fabric:latest` with added `yt-dlp` support
- Uses a non-root `appuser` for security
- Exposes port 8080 for the Fabric server
- Configuration directory: `~/.fabric-config` (mounted as `/home/appuser/.config/fabric`)

## Coding Guidelines

### Shell Scripts
- Use bash shebang: `#!/bin/bash`
- Include descriptive comments explaining script purpose and usage
- Validate prerequisites (e.g., config directory existence) before execution
- Provide helpful error messages with actionable guidance
- Use consistent error handling with appropriate exit codes
- Quote all path variables to handle spaces: `"$HOME/.fabric-config"`
- Check command exit codes and provide feedback: `if [ $? -ne 0 ]; then`

### Docker Practices
- Use the `jimscard/fabric-yt:latest` image for consistency
- Always mount the configuration directory: `-v "$HOME/.fabric-config:/home/appuser/.config/fabric"`
- Map port 8080 for server functionality: `-p 8080:8080`
- Use `--rm` for one-off commands to auto-cleanup
- Use `-d` with `--restart unless-stopped` for persistent services
- Name persistent containers consistently: `--name fabric-server`

### Code Style
- Use consistent indentation (tabs or spaces based on existing files)
- Add comments for complex logic or non-obvious behavior
- Keep scripts focused on a single purpose
- Validate inputs and provide usage messages
- Exit with meaningful status codes (0 for success, non-zero for errors)

## Testing and Validation

Since this is a shell script project with Docker dependencies:
- Test scripts manually with Docker installed
- Verify error handling by testing edge cases (missing config, Docker not running)
- Test both one-off and server modes
- Validate cleanup behavior (container removal, restart policies)
- Test port mapping and volume mounting functionality

## Common Tasks

### Adding New Scripts
1. Use bash shebang
2. Make executable: `chmod +x script-name.sh`
3. Follow naming convention: `*-fabric-d.sh`
4. Include usage instructions in comments
5. Test thoroughly with various scenarios

### Modifying Docker Image
1. Update `fabric-yt/Dockerfile`
2. Rebuild and test locally
3. Update documentation if changing exposed ports or volumes
4. Consider security implications (run as non-root user)

### Release Process
- Use `release-fabric-d-auto.sh` for versioning
- Follow semantic versioning
- Update release notes with changes
- Tag releases appropriately

## Security Considerations
- Scripts use non-root user (`appuser`) inside containers
- Configuration directory is isolated per user
- No hardcoded credentials or sensitive data
- Docker containers are isolated from host system
- Use `--rm` to automatically clean up temporary containers

## Dependencies
- Docker (required for all functionality)
- Bash (shell scripts)
- Git (for release management)
- User must have Docker permissions (member of docker group or sudo access)

## Future Enhancements
- Homebrew tap installation support (planned)
- Custom tap with symlinks to bin directory without .sh extensions
