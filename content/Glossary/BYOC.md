Bring Your Own Cloud

Many applications are following client-server architecture. They usually have mobile app (iOS or Android) that talks to server app. And the server app is usually does not belongs to user. And when server goes down, there is nothing user can do.

But actual complete application that should be delivered to the user is client and server combined - they are just separate components of the product.

## Self-hosted rabbit hole

Our [[Philosophy]] stands that server (aka backend) software should belong to user. 

And there a lot of applications that user can host on its own, without vendor-lock.

But most of them *expect user to run server software somehow*, usually as a set of  containers. Then network address of these containers is configured in reverse-proxy for service to have human-readable address. And often that address is then used to setup client app, e.g. application on Android to use that server software. This requires *not a basic level of technical knowledge*.

## One-click setup

BYOC does inversion of control. Instead of user setting up server software, the client app does it.

## Example

User installs Pixelfed app (federated alternative to Instagram [[VLOP]]) on their iPhone. Currently, two options are given:
* *Create account on pixelfed.org*
* Or *provide self-hosted instance address* (which should be already configured and running)
Best user-experience is combining "one-click sign-up" with "setting up self hosted instance".

With BYOC app should only ask:
* *Address of your own private cloud*: `robhomelab.nl` (user types in)

And this address user types in any other application: Matrix client, Photo management app, Music streaming etc.

BYOC SDK standardize the way app takes address like `robhomelab.nl` and let application to discover or setup server part of the application.