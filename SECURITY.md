# Security Policy

## Supported Versions

As-of right now, only the latest patch version of the `0.5.x` branch is supported. All other versions are End of Life and will no longer receive updates. Update your applications to use version `0.5.x`. Future deprecated versions will receive one year of updates after deprecation and stop receiving updates once the gem signing certificate associated with the last version expires.

| Version | Supported                  | End of Life |
| ------- | -------------------------- | ----------- |
| 0.5.x   | :white_check_mark: Current |             |
| 0.4.x   | :x: End of Life            | 2024-02-23  |
| 0.3.x   | :x: End of Life            | 2024-02-23  |
| 0.2.x   | :x: End of Life            | 2024-02-23  |
| 0.1.x   | :x: End of Life            | 2024-02-23  |

## Certificate Signing and Checksums

The gem is currently released with a certificate so it can be installed with the `HighSecurity` policy. The SHA-256 and SHA-512 of each released version of the gem is kept in the `checksum` directory of the GitHub repository.

## Reporting a Vulnerability

Please report (suspected) security vulnerabilities to security@statelesscode.com. We make no guarantees related to turnaround time. If the issue is confirmed, we will release a patch as soon as possible depending on complexity and severity.
