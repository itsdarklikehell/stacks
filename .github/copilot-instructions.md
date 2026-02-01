<!-- Copilot / AI agent instructions for the `stacks` repository -->

Doel: snel productief in deze repo — concrete regels, voorbeelden en files om direct bruikbare code- of documentwijzigingen te maken.

- **Kernoverzicht:** deze repo bevat meerdere "stacks": service-folders, `Dockerfile-<name>`-images, en veel start/install scripts in `SCRIPTS/`.

- **Belangrijke bestanden & directories (lees eerst):**
	- [install-stack.sh](install-stack.sh) — host bootstrap en orchestratie hooks.
	- `SCRIPTS/` — zoek `install_*`, `start_*`, `pull_models.sh`, `install_docker.sh` voor concrete workflows.
	- `DATA/` (bijv. `DATA/ai-stack/`, `DATA/models/`) — modellen en runtime data staan hier.
	- `SECRETS/` — verwachte secret-bestanden (nooit committen).

- **Conventies die je moet volgen:**
	- Dockerfiles: `Dockerfile-<service>` (zoek op `Dockerfile-`).
	- Start scripts: `SCRIPTS/start_<service>.sh` (soms met een `.desktop` launcher).
	- Config defaults: `SCRIPTS/conf-*.yaml` of `conf-*.yml` naast scripts.
	- Grote modellen/artifacten: plaats in `DATA/`; services verwachten mounts van `DATA/` en `SECRETS/`.

- **Direct bruikbare voorbeelden (PR-tekst):**
	- "Toegevoegd: `Dockerfile-xyz`, `SCRIPTS/start_xyz.sh`; nieuwe data: `DATA/xyz/`; vereiste secrets: `SECRETS/xyz`."
	- "Reproduceren: run `SCRIPTS/install_docker.sh` && `SCRIPTS/start_xyz.sh` (controlleer DATA/xyz en SECRETS/xyz)."

- **Belangrijke commands:**
	- Bootstrap host: `./install-stack.sh`
	- Install Docker: `SCRIPTS/install_docker.sh`
	- Haal modellen op: `SCRIPTS/pull_models.sh` (open dit script voor endpoints/auth)

- **Debugging checklist:**
	- Bekijk logs in relevante `DATA/` subfolders en `logs-` dirs in `SCRIPTS/`.
	- Inspecteer `Dockerfile-<name>` op ontbrekende build-steps (apt/pip) bij runtime-fouten.
	- Controleer dat `DATA/<stack>` en `SECRETS/<name>` op de host aanwezig zijn en correcte permissies hebben.

- **Agentregels (kort):**
	- Doe: update corresponderende `SCRIPTS/` start/install scripts bij nieuwe services.
	- Doe: documenteer exact welke bestanden/paden veranderen in PR-omschrijving.
	- Doe niet: secrets committen — verwijs naar `SECRETS/` en documenteer verwachte bestandsnamen.

- **Integratie & externe afhankelijkheden:**
	- Grote downloads en modellen worden beheerd door `SCRIPTS/pull_models.sh` — volg dit script voor externe endpoints en credentials.
	- Er is geen centrale CI/test runner — verifieer wijzigingen door lokale container builds en start-scripts.

Als je wilt kan ik nu:
- 1) toevoegen van een PR-tekst-template voor nieuwe services, of
- 2) een korte checklist voor handmatige validatie genereren.
Welke optie wil je eerst?

