Users may benefit from having some backends that are shared across servlets.  
  
This could be, for example, data aggregation services like search engine. We should enable to declare dependency on such service, and that service may be shared with other apps.  
THis however will lead to versioning problem. What if app A requires search engine v1, and app B requires search engine v2?  
    - This might be solved by duck typing.  
    - Or, instead of intriducing dependency, we should let search engine itself discover existing backend and dela with them the way they are.  
  
  
Use cases:  
 - RSS/ActivityPub/ATProto aggregation for social discovery/interaction  
 - Search engine, sitemap builder  
 - Analytics  
  
Types of integration:  
* aggregator looks into BYOC API and discovers all deployed resources, them access them giving available information  
    - in this case, security is managed by apps - they may or may not let aggregator to access resources  
    - maybe we should provide standard way to authorize apps between each other  
* middleware injects into ingress, then manipulates requests/responses  
    - this may be very useful if we want app to inject code or something like this  
    - but it's hard to define approach that simple and secure in the same time  
       - some bad actor can install middleware that steals data  
       - in the same time it's hard to educate users on how they should manage middleware - they will simple install "Analytics for BYOC"  
    - so probably, it's app to "blog app" to somehow let "analytics app" to integrate  
       - or maybe it's "blog app" acts as search engine in previous example, it discovers "analytics app" in user's cloud and talks to it