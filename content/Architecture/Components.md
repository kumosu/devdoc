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
