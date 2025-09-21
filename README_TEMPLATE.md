# Stack README Template & Best Practice Checklist

## 1. Overview
- **Stack Name:**
- **Purpose:**
- **Main Services:**

## 2. Quick Start

- Prerequisites (Docker, Docker Compose, etc.)
- How to deploy: `docker compose up -d`
- How to stop: `docker compose down`
- How to update: `docker compose pull && docker compose up -d`

## 3. Environment Variables
- All variables are defined in `.env.example` and `.env`.
- Sensitive values use Docker secrets where possible.

Checklist:
  - [ ] All variables documented
  - [ ] `.env.example` is up to date

## 4. Network Segmentation
- List all networks used by this stack:

  - [ ] Only required networks are attached to each service
  - [ ] No unnecessary inter-stack communication
  - [ ] Custom network policies documented

## 5. Volumes & Backups
- List all named volumes:
- Backup strategy:

  - [ ] All volumes included in backup
  - [ ] Restore procedure documented
  - [ ] Offsite/cloud backup for critical data

## 6. Secrets Management
- List all secrets used:

Checklist:
  - [ ] Secrets are not committed to version control
  - [ ] Secret rotation policy in place

## 7. Resource Limits & Healthchecks
- [ ] All main services have `deploy.resources` limits
- [ ] All main services have healthchecks
- [ ] Images are version-pinned where possible

## 8. CI/CD
- [ ] GitHub Actions or similar pipeline in place
- [ ] Linting and YAML validation included
- [ ] Test deployment step included

## 9. Manual Steps & Customizations
- [ ] All manual steps are documented here
- [ ] All customizations are explained

## 10. Troubleshooting & Support
- Common issues and solutions
- Where to get help

---
## Example Network Policy Table

| Service      | Networks Attached      | Notes                  |
|--------------|-----------------------|------------------------|
| service1     | ai-stack, proxy       | Only needs ai-stack    |
| service2     | management-stack      | OK                     |

---
## Example Backup Table

| Volume Name      | Description         | Included in Backup? |
|------------------|--------------------|---------------------|
| mydata           | Main DB            | Yes                 |
| config           | App config         | Yes                 |

---
## Example CI/CD Status Badge

```
![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)
```
# Stack README Template & Best Practice Checklist

## 1. Overview
- **Stack Name:**
- **Purpose:**
- **Main Services:**
- **Key Features:**

## 2. Quick Start
- Prerequisites (Docker, Docker Compose, etc.)
- How to deploy: `docker compose up -d`
- How to stop: `docker compose down`
- How to update: `docker compose pull && docker compose up -d`

## 3. Environment Variables
- All variables are defined in `.env.example` and `.env`.
- Sensitive values use Docker secrets where possible.
- Checklist:
  - [ ] All variables documented
  - [ ] `.env.example` is up to date

## 4. Network Segmentation
- List all networks used by this stack:
  - [ ] Only required networks are attached to each service
  - [ ] No unnecessary inter-stack communication
  - [ ] Custom network policies documented

## 5. Volumes & Backups
- List all named volumes:
- Backup strategy:
  - [ ] All volumes included in backup
  - [ ] Restore procedure documented
  - [ ] Offsite/cloud backup for critical data

## 6. Secrets Management
- List all secrets used:
- Checklist:
  - [ ] Secrets are not committed to version control
  - [ ] Secret rotation policy in place

## 7. Resource Limits & Healthchecks
- [ ] All main services have `deploy.resources` limits
- [ ] All main services have healthchecks
- [ ] Images are version-pinned where possible

## 8. CI/CD
- [ ] GitHub Actions or similar pipeline in place
- [ ] Linting and YAML validation included
- [ ] Test deployment step included

## 9. Manual Steps & Customizations
- [ ] All manual steps are documented here
- [ ] All customizations are explained

## 10. Troubleshooting & Support
- Common issues and solutions
- Where to get help

---

## Example Network Policy Table
| Service      | Networks Attached      | Notes                  |
|--------------|-----------------------|------------------------|
| service1     | ai-stack, proxy       | Only needs ai-stack    |
| service2     | management-stack      | OK                     |

---

## Example Backup Table
| Volume Name      | Description         | Included in Backup? |
|------------------|--------------------|---------------------|
| mydata           | Main DB            | Yes                 |
| config           | App config         | Yes                 |

---

## Example CI/CD Status Badge
```
![CI](https://github.com/<owner>/<repo>/actions/workflows/ci.yml/badge.svg)
```
