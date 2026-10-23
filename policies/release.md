# Production Release Policy

Load this policy only when preparing or shipping a production website or application. It does not block local prototypes.

## Release Checks

- Confirm the production domain and DNS ownership/configuration before changing domain, canonical, or redirect settings.
- Verify HTTPS, canonical URLs, page metadata, sitemap, and robots directives where applicable. Never invent indexing or ranking outcomes.
- Confirm favicon/branding and remove unwanted framework branding only when requested or required by the product.
- Confirm navigation, forms, authentication, and integrations work in the target environment.
- Review privacy and terms requirements for the product and jurisdiction. Do not claim legal compliance; request qualified review when needed.
- Check for exposed secrets and run the applicable security review in `policies/security.md`.
- Run build, type checking, linting, tests, and relevant runtime checks that the project actually defines.
- Inspect desktop and mobile layouts, including meaningful interaction states and accessibility.
- Record anything unverified. A local check is not proof of production behavior.

## Release Decision

Report **ready**, **not ready**, or **partially verified** with evidence. Do not mark a release ready while a known blocker remains or claim that a production deployment was tested when it was not.

