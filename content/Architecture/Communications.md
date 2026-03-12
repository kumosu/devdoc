  
Types:  
- Internet -> Servlet  
    - Authenticated user -> Servlet  
    - Guest -> Servlet  
- Servlet -> Internet (egress)  
- Servlet -> Servlet  
No resources (db, s3 buckets, queues) are shared between servlets.

## Access control

It is important for server app to be able to distinguish between:
* authenticated user access it directly
* web application access backend on behalf of a user
* another server app access it
* or just guest from internet reached out
