Financial side of any content in the web is always about who pays and for what.
If content is free and there is no ads, it's only because of some volunteer behind it.
  
There is different :  
* paid chat to the author  
* access to content (single piece or subscription)  

Who pays:  
* user pays  
* user pays for a group of user (family access)  
* advertiser pays in exchange to show consumer ads along the content  
  
This is not direct concert of BYOC, but the architecture should allow this use-case.  
  
Example of such arch is:  
* separate "Monetization" app with its own servlet  
* non-invasive integration:  
    * servlet gates access to a URL without interaction with underlying app  
* invasive integration:  
    * an app's servlet (e.g. blog) follows x402 protocol and return HTTP 402 when necessary, the "Monetization" app handles this response to enable users do the payment