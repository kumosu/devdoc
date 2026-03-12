Target architecture is serverless. Application code should run in a secure sandboxed environment, any I/O is handled by host.

There are several options:
* WASM
* JavaScript
* Lua
* microVMs
* Linux containers

## I/O isolation

Cloudflare Workers bet on JS and WASM. These are really good choices. WASM is high performance and can be built from many languages. JavaScript has great library of code, known very well by many developers. Both allow dynamic linking of I/O code. For example, app's code just calls SQL.exec("query") and the rest is handled by host. This gives great flexibility and control in the host system.
This is different from microVM approach, where pure network/block_storage access is required. So network is controlled only on network device level (L2-L3), while on JS/WASM network is managed on wider range (L3-L7 - whatever interface is linked).

### Specific tasks

The more specialized functionality is off-loaded the more flexibility runtime has. And it it possible to achieve greater efficiency of host system.
For example, it is better if database is provided by host system, instead of host system to allow to run a database. Because several apps could use single database.

Other examples of such tasks:
* ML inference
	* host can run it on GPU or use inference API like HuggingFace
* Queues, KV and SQL storage
	* backups, failover and multitenancy is handled by host
* CDN, audio/video transcoding
* Complex networking: BitTorrent, WebRTC, IPFS
	* more efficient and secure if managed by host

## User-owned environment - philosophical stance

Beside just efficiency, from philosophical stance, it is also rightful if I/O is controlled by host. Because host is controlled by user.
By moving arbitrary code's interface from L2 to L7 (in OSI perspective), we are helping users exercise complete control of what arbitrary application is doing.

## Docker containers

There is currently too much great self-hosted software that are only distributed as docker containers. And there is almost no software for isolated environment like CloudFlare Workers.

We should let run Docker containers but with many limitations:
* limited set of stateful resources (SQL, KV, Queues) configured via env variables
* no disk volumes available
* ideally L7+ networking via proxies
* whitelisting
	* (without configuration flag) client apps can't deploy arbitrary docker containers to avoid running malware that can abuse user's cloud or exploit vulnerabilities in container isolation