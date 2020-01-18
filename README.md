# Zero Tier Guide
Zerotier is a Self-Hosted Virtual Network Platform that provides end-to-end encryption for all network traffic. Allowing computers to be connected to a virtual network controlled via My Zerotier (Zerotier Hosted) or self-hosted.

With Zerotier and PTS PortGuard you can create a secure connection to your PTS server, this will allow you to access your server without OAUTH access and direct access to the servers ports (SSH, Telnet, FTP, etc.), minimizing exposure to the public Internet. This will allow you to close those ports on your Public IP firewall, thus increasing your security and enhanced connectivity.

# Getting Started
To get started with ZT you will first need to create an account at https://my.zerotier.com/login. 

## Create a ZeroTier Account
1. Go-to https://my.zerotier.com/login.
1. Click Login.
1. click Log-In to ZeroTier.
1. Click Login in with Google.
1. Authorize Google Account.
1. Select free account (default).

## Create a Network (Network ID)
1. Click Networks
1. Click Create a Network
*a network will be create with a random name*
*Document your Network ID*

## Managing your network
From this page you can rename your network add a discription and also allow client to connect.

To access the network page simply click your network ID

### Setting ip Range
A default ip range is set for each network you create. You can change this ip range to a predifined or choose your own range

### Approving Members
to allow a client to connect to the ZeroTier network you must authorise the client.

A client will appear in the members section once they have connected to the network, This does not give them access. For acces to be granted they must be authorised.

To authorise a member first find them in the members section.

*You will notice that they do not have an IP this will not be populated till they are authorised.
*

From this section you can assign them a name and description and also manually assign an ip

# Installing ZeroTier
Now we have our ZeroTier account and network ID it is time to install ZeroTier

To install ZeroTier choose PTS-ZeroTier from the menu.
You will need to know your Network ID.
set your network ID
This will restart your Zerotier Docker and Connect to network
Next Authorise your server in your Zerotier Network
Document your IP
Select Setup IP
Set your Zerotier IP from the network Page
Deploy ZT

#What did this Do
Wht this script has done is configured Zerotier and Join it to your Zerotier Network
With PortGaurd Enabled it blocks access to docker ports this script changes the Docker containers to allow Zerotier Traffic on the ports.
This does not Open your ports.

Configure DNS + Organizr + Traefik
Coming Soon


