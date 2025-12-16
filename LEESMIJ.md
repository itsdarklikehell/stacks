# Stacks — README

Kort overzicht

- **Doel**: Deze repository bevat een modulair, Docker-gebaseerd stacksysteem voor AI, Essentials, Management en Media services.
- **Hoofdcomponenten**: AI Stack, Essentials Stack, Management Stack, Media Stack.

**Quick Start**

- **Build & start**: Gebruik `docker-compose up --build` om de stacks te bouwen en te starten.
- **Stoppen**: Gebruik `docker-compose down`.
- **Logs**: Controleer runtime logs via Docker of in `/var/log/ai-stack/` voor AI-stack logs.

**Stacks**

- **AI Stack**: [ai-stack/](ai-stack/) — Orkestreert AI/ML services waaronder:
  - **AnythingLLM**: Documentverwerking en LLM-integratie.
  - **Ollama**: Lokale LLM-hosting.
  - **Faster-Whisper**: GPU-versnelde spraakherkenning.
  - **Home Assistant**: IoT-automatisering.
  - **LibreTranslate**: Zelf-gehoste vertaling.
- **Essentials Stack**: [essential-stack/](essential-stack/) — Basisdiensten en infrastructuur.

**Belangrijke commando's**

- Start en bouw alle services:

```bash
docker-compose up --build
```

- Draai integration tests voor de AI Stack:

```bash
docker-compose run --service ai-stack integration-tests
```

**Configuratie**

- **Env vars**: Configuratie gebeurt via environment variables.
- **Datastores**: PostgreSQL wordt gebruikt voor persistente opslag; connectie-instellingen zitten in de compose-configuratie ([docker-compose.yml](docker-compose.yml) indien aanwezig).
- **Netwerk**: Services communiceren via gRPC waar aangegeven.

**Conventies**

- **Naamgeving**: Gebruik snake_case voor servicenames en variabelen.
- **Bestanden**: Docker Compose op root-niveau definieert services en volumes.
- **Code stijl**: Volg bestaande projectconventies per stack.

**Integratiepunten**

- **AnythingLLM**: Integreert met externe API's voor documentverwerking (controleer service-definitie in [ai-stack/](ai-stack/)).
- **Ollama**: Vereist een bereikbare Ollama-server.
- **gRPC**: Meerdere services gebruiken gRPC; gebruik `grpcurl` om services te inspecteren en te debuggen.

**Debugging & Logging**

- **Docker logs**: `docker-compose logs -f <service>`
- **Lokale logs**: Bekijk `/var/log/ai-stack/` voor AI-stack-specifieke logs.
- **gRPC debug**: `grpcurl` voor schema-inspectie en call-testing.

**Testing**

- **Integratie-tests**: In de `ai-stack` map; draai ze met de hierboven vermelde `docker-compose run`-opdracht.
- **Locatie tests**: [ai-stack/](ai-stack/) bevat test-configuratie en scripts.

**Contributing**

- **Werkwijze**: Fork, feature branch, open PR met duidelijke beschrijving en tests waar relevant.
- **Code review**: Voeg commit- en PR-beschrijvingen toe met reproduceerbare stappen.

**License**

- **Status**: Geen licentiebestand in deze README genoemd — voeg een `LICENSE` toe als je een specifieke licentie wil publiceren.
