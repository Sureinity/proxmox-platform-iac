# DMZ Design

## Purpose

The `edge` zone is the platform DMZ. It contains public-facing ingress components and forms the boundary between untrusted clients and trusted internal services.

In Version 1, the primary DMZ workload is the Traefik reverse proxy VM.

## Trust Model

The DMZ is semi-trusted.

That means:

- it is expected to receive untrusted inbound traffic
- it may terminate TLS and perform routing decisions
- it is not allowed to inherit trust into internal zones
- compromise of the DMZ must not provide direct access to `app`, `data`, or `mgmt`

The DMZ is therefore an exposure boundary, not a trusted control plane.

## Allowed Traffic Paths

The `edge` zone is intended to allow:

- inbound client traffic from external networks to explicitly published reverse-proxy listeners
- outbound proxy traffic from `edge` to `app` on approved backend service ports
- restricted operator access from `mgmt` for administration, automation, and troubleshooting
- response traffic for established connections

Any additional path must be treated as an exception and justified in the network policy.

## Denied Traffic Paths

The `edge` zone is intended to deny:

- direct inbound access from external networks to `app`, `data`, or `mgmt`
- direct initiated traffic from `edge` to `data`
- direct initiated traffic from `edge` to `mgmt`
- unrestricted east-west traffic from `edge` to internal zones
- use of the DMZ as a transit path for administrative trust

If a service in `edge` requires access beyond reverse-proxy behavior, that requirement must be documented and reviewed as a specific exception.

## Operational Consequences

- Secrets required by internal services must not be staged in the DMZ unless they are strictly required by the reverse proxy role.
- Platform operators should assume the `edge` zone has the highest exposure and the shortest acceptable mean time to rebuild.
- Logging, access policy, and certificate handling for the DMZ should be treated as security-sensitive controls even in Version 1.

## Version 1 and Version 2 Boundary

Version 1 uses reverse proxy ingress only.

Version 2 may add WAF controls. The DMZ design does not assume a WAF is present today, and no Version 1 document should claim otherwise.
