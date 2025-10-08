| Env Variable                        | Purpose                                   | Default / Notes                                  |
| ----------------------------------- | ----------------------------------------- | ------------------------------------------------ |
| `PDS_PORT`                          | Port the service will run on              | `2583`                                           |
| `PDS_HOSTNAME`                      | Hostname of the server                    | `"localhost"`                                    |
| `PDS_SERVICE_DID`                   | DID for the service                       | `"did:web:{hostname}"`                           |
| `PDS_VERSION`                       | Version string of the service             | None                                             |
| `PDS_PRIVACY_POLICY_URL`            | URL for privacy policy                    | None                                             |
| `PDS_TERMS_OF_SERVICE_URL`          | URL for terms of service                  | None                                             |
| `PDS_ACCEPTING_REPO_IMPORTS`        | Whether the server accepts repo imports   | `true`                                           |
| `PDS_BLOB_UPLOAD_LIMIT`             | Max upload size in bytes                  | `5 * 1024 * 1024` (5MB)                          |
| `PDS_CONTACT_EMAIL_ADDRESS`         | Contact email address                     | None                                             |
| `PDS_DEV_MODE`                      | Enable development mode                   | `false`                                          |
| `PDS_DID_PLC_URL`                   | PLC directory URL                         | `"https://plc.directory"`                        |
| `PDS_ID_RESOLVER_TIMEOUT`           | Resolver timeout in milliseconds          | `3000` (3 seconds)                               |
| `PDS_DID_CACHE_STALE_TTL`           | Cache stale TTL in milliseconds           | `3600` (1 hour)                                  |
| `PDS_DID_CACHE_MAX_TTL`             | Cache max TTL in milliseconds             | `86400` (1 day)                                  |
| `PDS_RECOVERY_DID_KEY`              | Optional recovery DID key                 | None                                             |
| `PDS_SERVICE_HANDLE_DOMAINS`        | List of handle domains                    | `[".test"]` if localhost, else `[".{hostname}"]` |
| `PDS_HANDLE_BACKUP_NAMESERVERS`     | Optional backup name servers              | None                                             |
| `PDS_ENABLE_DID_DOC_WITH_SESSION`   | Enable DID doc with session               | `false`                                          |
| `PDS_BSKY_APP_VIEW_URL`             | URL for Bluesky AppView service           | Optional                                         |
| `PDS_BSKY_APP_VIEW_DID`             | DID for AppView service                   | Required if AppView URL is set                   |
| `PDS_BSKY_APP_VIEW_CDN_URL_PATTERN` | CDN URL pattern for AppView               | Optional                                         |
| `PDS_MOD_SERVICE_URL`               | URL for moderation service                | Optional                                         |
| `PDS_MOD_SERVICE_DID`               | DID for moderation service                | Required if Mod Service URL is set               |
| `PDS_REPORT_SERVICE_URL`            | URL for reporting service                 | Optional                                         |
| `PDS_REPORT_SERVICE_DID`            | DID for reporting service                 | Required if Report Service URL is set            |
| `PDS_MAX_SUBSCRIPTION_BUFFER`       | Max subscription buffer size              | `500`                                            |
| `PDS_REPO_BACKFILL_LIMIT_MS`        | Repository backfill limit in milliseconds | `86400` (1 day)                                  |
| `PDS_INVITE_REQUIRED`               | Whether invites are required              | `true`                                           |
| `PDS_INVITE_INTERVAL`               | Interval between invites                  | Optional                                         |
| `PDS_INVITE_EPOCH`                  | Starting epoch                            | `0`                                              |
| `PDS_CRAWLERS`                      | List of crawler identifiers               | Optional                                         |
