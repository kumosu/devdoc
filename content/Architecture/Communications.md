  
Types:  
- Internet -> Servlet  
    - Authenticated user -> Servlet  
    - Guest -> Servlet  
- Servlet -> Internet (egress)  
- Servlet -> Servlet  
No resources (db, s3 buckets, queues) are shared between servlets.
