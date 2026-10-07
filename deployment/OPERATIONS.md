# Apollo deployment and recovery

Status: prepared configuration. A running service, authenticated session, remote client use and unattended reviews must be verified before completion.

## Access boundary

Use OpenAI Secure MCP Tunnel with a stdio child inside the same container. Publish no ports. The dedicated Docker bridge does not join other household container networks. It permits outbound access for the tunnel and Monarch; Docker’s bridge alone is not a destination firewall for the rest of the LAN. The health/admin listener binds only to 127.0.0.1 inside the container.

The Monarch server has no separate OAuth user identity. All authorized tunnel callers share Craig’s Monarch session. Only Craig’s personal Platform organization and intended ChatGPT workspace should be associated with the tunnel. Review membership before adding real credentials. Tunnel authorization and Monarch sign-in are separate; stdio removes the raw unauthenticated HTTP listener. If multiple users must be supported, add an authenticated per-user gateway before expanding access.

## Build and record

From a clean checkout of the tested fork commit on x86_64 Apollo:

```sh
docker build --pull -t monarch-base:SOURCE_COMMIT .
docker build --build-arg CONNECTOR_IMAGE=monarch-base:SOURCE_COMMIT -f deployment/Dockerfile.tunnel -t monarch-private:SOURCE_COMMIT .
docker image inspect monarch-base:SOURCE_COMMIT monarch-private:SOURCE_COMMIT --format '{{.Id}}'
```

Use real source commit values. Record the final image ID, base image digest, build log and tunnel-client version; local image ID and registry digest are distinct. The tunnel binary is v0.0.16, from OpenAI’s official release, with Linux amd64 archive SHA256 `d60cdba019bce451bcc3a15478cc5b9cb11270b049f5b56ea39a80b517f8b117`. Check latest upstream and tunnel releases when maintaining, and review before replacing pins.

## Secret placement

Apollo’s appdata is cache-only and is not encrypted. Parent mode 0777 must not be inherited by the finance directory. Create a finance parent at mode 0700; `session`, `config`, and `secrets` at mode 0700 owned by uid/gid 10001. Put the runtime key only in `secrets/openai-runtime-key` (0600, uid 10001) and the nonsecret configuration in `config/tunnel.yaml`. The example file contains a placeholder tunnel ID and must be completed locally. Avoid keys in environment variables, shell history or command arguments.

Choose the protection policy before real sign-in. Permissions protect ordinary users but not Apollo root or Docker administrators. Options include a dedicated encrypted dataset with separately retained recovery key or explicit acceptance of existing unencrypted storage. Do not claim this system has encrypted credentials. Do not back up sessions into ordinary appdata archives until the backup protection policy is chosen. Reauthentication instead of copying sessions is a viable recovery policy.

Authenticate with a separate interactive container using the connector image and session mount. Craig enters his own password/MFA. Do not extract browser cookies automatically or paste secrets into chat. Browser-cookie sign-in is an upstream-supported fallback that Craig can choose if password sign-in hits CAPTCHA. Do not store cookie exports in the repository or build context.

## Start and prove readiness

Run `deployment/run-apollo.sh sha256:RECORDED_IMAGE_ID /mnt/cache/appdata/monarch-mcp` only after the tunnel association and protected storage are approved. No network port is published. Check container running state and health separately:

```sh
docker inspect monarch-private --format '{{.State.Status}} {{.State.Health.Status}}'
docker exec monarch-private python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8080/readyz').status)"
docker port monarch-private
```

An empty port listing is expected. Healthy readiness establishes tunnel connection, not financial data accuracy. Register the private custom connector while the daemon is running and test discovery, one sample read and the expected full tool list from each client.

## Recovery and upgrades

For a container-only restart: restart `monarch-private`, check readiness, then run one read. Avoid restarting Docker, Apollo or household services.

For an upgrade: retain the prior image ID and source commit, stop only the finance container, rename it as the rollback container, build from a tested fork commit, and launch the replacement with the same approved storage. Validate readiness, read reconciliation and a suitable reversible correction. On failure, stop the replacement and restore the prior named container/image. Never delete the previous image before the new one passes validation.

For a lost/expired Monarch session: Craig signs in locally again. For compromise: stop the connector, revoke the OpenAI runtime key and tunnel access, revoke Monarch sessions through Monarch, then provision new credentials. Removing the container alone does not revoke a copied Monarch session.

Recovery testing must restore a protected synthetic or real session in a separate container without publishing ports or sharing the active session across writers. Record actual test results; this document is not evidence of a completed restore.

## Scheduler boundary

The connector provides tools; it does not schedule AI reviews. Desktop automations require the Mac, and cannot meet the sleeping-Mac acceptance test. Verify a hosted ChatGPT/Work scheduler can invoke this private connector, or obtain approval for a separate Apollo runner and API usage budget. Do not start background API spending from this deployment script. Daily exceptions, weekly digest and monthly planning remain the proposed cadence until Craig chooses times and thresholds.

## Runtime key lifecycle

The initial dedicated key is restricted to Tunnels Read and Use, with every model and data permission set to None. Its proposed setup expiry is 30 days. This limits the credential to the connector transport; it is not a budget for an AI review runner. Before expiry, Craig creates a replacement with the same narrow permissions, supplies it through a masked local prompt, and restarts only the finance container. Verify readiness and one client read before revoking the old key. Calendar maintenance and automatic replacement have not been configured.
