# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.x     | :white_check_mark: |
| 1.x     | :x:                |

## Reporting a Vulnerability

The security of this configuration matrix and user scripts is taken seriously.

If you discover a security vulnerability, please do NOT create a public issue. Instead, report it privately:

1. **Email**: Open an advisory via GitHub Security Advisories or contact Karan Singh Verma.
2. **Details**: Provide a clear description of the vulnerability, reproduction steps, and potential impact.
3. **Response Timeline**: You can expect an initial response acknowledging receipt within 48 hours.

## Security Practices
- **No Hardcoded Secrets**: All user configs, hostnames, and credentials must use dynamic environment variables (`~/.peer_pc.env`).
- **Least-Privilege SSH**: Key-based authentication (Ed25519) only. Password authentication should be disabled.
- **Wake-Lock Supervision**: Ensure foreground battery optimization exclusions are managed responsibly.
