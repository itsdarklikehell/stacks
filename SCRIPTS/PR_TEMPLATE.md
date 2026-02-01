# PR Template for adding a new service

Title: Add <service-name> (Dockerfile + start script)

- What: One-line summary of the change.
- Files changed/added:
  - Dockerfile-<service-name>
  - SCRIPTS/start_<service-name>.sh
  - SCRIPTS/conf-<service-name>.yaml (optional)
  - DATA/<service-name>/ (if applicable)
- Data requirements: list any model blobs or large files and their expected paths under `DATA/`.
- Secrets: list expected secret filenames under `SECRETS/` (do NOT include secret values).

How to reproduce locally:

```bash
SCRIPTS/install_docker.sh && SCRIPTS/start_<service-name>.sh
# check DATA/<service-name> and SECRETS/<service-name>
```

Notes:
- Mention required runtime (ports, GPUs, special drivers).
- If the service needs additional OS packages, include them in the Dockerfile and document them here.
