# Zero Tier Guide
Zerotier is a Self-Hosted Virtual Network Platform that provides end-to-end encryption for all network traffic. Allowing computers to be connected to a virtual network controlled via My Zerotier (Zerotier Hosted) or self-hosted.

With Zerotier and PTS PortGuard you can create a secure connection to your PTS server, this will allow you to access your server without OAUTH access and direct access to the servers ports (SSH, Telnet, FTP, etc.), minimizing exposure to the public Internet. This will allow you to close those ports on your Public IP firewall, thus increasing your security and enhanced connectivity.

# Getting Started
To get started with ZT you will first need to create an account at https://my.zerotier.com/login. 

## Create a ZeroTier Account
1. Go-to https://my.zerotier.com/login.
1. Click Login.
1. Click Log-In to ZeroTier.
1. Click Login in with Google.
1. Authorize Google Account.
1. Select free account (default).

## Create a Network (Network ID)
1. Click Networks
1. Click `Create a Network`
*a network will be create with a random name*
*Document your Network ID*

## Managing your Network
From this page you can rename your network add a description and also allow client to connect.

To access the network page, simply click your network ID.

### Setting IP Range
A default ip range is set for each network you create. You can change this ip range to a predefined or choose your own range (with correct CIDR Notation)

### Approving Members
To allow a client to connect to the ZeroTier network you must authorize the client.

A client will appear in the members section once they have connected to the network, this does not give them access. For access to be granted they must be authorized.

To authorize a member, first find them in the members section.

*You will notice that they do not have an IP, this will not be populated till they are authorised.
*

From this section you can assign them a name and description and also manually assign an IP.

# Installing ZeroTier
Now we have our ZeroTier account and network ID it is time to install ZeroTier

To install ZeroTier, choose PTS-ZeroTier from the menu.

(1) Set your network ID

Note: This will restart your Zerotier Docker and Connect to your Network

(2) Next authorize your server in your Zerotier Network

(3) Document your IP

(4) Select Setup IP

(5) Set your Zerotier IP from the Network Page

(6) Deploy ZeroTier

# What did this Do
What this script has done is configured Zerotier and join it to your Zerotier Network
With PortGuard, Enabled it blocks access to docker ports this script changes the Docker containers to allow Zerotier Traffic on the ports.
This does not open your ports.



Configure DNS + Organizr + Traefik
Coming Soon


