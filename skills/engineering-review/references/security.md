# Security Review Reference

Load when the diff crosses a trust boundary or changes authentication, authorization, secrets, sensitive data, file/network access, deserialization, or privilege.

Focus on concrete attack paths:

- identify attacker-controlled input
- identify the trusted operation reached
- identify missing or misplaced authorization
- verify tenant/resource ownership
- verify output encoding in the actual sink context
- inspect secrets, logs, tokens, cookies, redirects, files, URLs, and parsers
- verify the installed framework version before relying on defaults

Do not report a vulnerability without a credible path and material consequence.
