Private cloud should be composable. 
All-In-One (AIO) setup shows what components are actually needed:
* **Identity provider (OIDC)**
  this authorizes user to deploy server apps, also enables multi-tenancy and granular access control
* **BYOC API**
  authorized (client) apps use BYOC API to see deployed apps and deploy new ones, establish communication with them
* **k9s** (container environment)
  Kubernetes provides standard way to run containers, while enabling setups with multiple computers. Reconciliation provides robust way to manage applications. k9s is all-in-one binary for small setups.
* **Dashboard**
  Management of the private cloud is still needed - to register new users (sharing same instance with friends). But this is also an entrypoint for installing web applications ([[Web apps marketplace]])

## Specific components

k9s as containerized env
Caddy as http gateway / reverse-proxy
Rauthy as Identity Provider

BYOC Controller provides CRUD access to apps and reconcile them as Kubernetes deployments and caddy routes.


## Server apps lifecycle

### Creation

Server apps create either by client apps or from a marketplace.

### View

Authenticated client apps can see all server apps. The should be able to know metadata (name, perhaps what software is running (docker tag)) and runtime information (status, endpoints).

> knowing endpoint does not necessarily means any client app can do anything in any server app - because it for server app to decide
> Some services can be available to any client app or vice versa some app would like to reach everything open - e.g. search engine.
> It is only important for backend apps to see where input comes from, see [[Communications]]

### Changes

If app is installed from a marketplace - updates can be done by the marketplace, perhaps there is also some configuration interface in the UI.
If client apps has installed the app - it is under control
