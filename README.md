# nginx-virtualhost-generator
A CLI-based tool that helps you generate NGINX server block configuration files in a few seconds.






![alt text](http://i.imgur.com/sxcQnCN.png)


<h2>Prelude</h2>

If you are tired from creating and configuring virtual hosts and directories on NGINX and wasting time and resources on syntax errors and unexpected HTTP response codes with php, nodejs, etc .. Or if JSON is not your cup of tea.. This tool is for you!
Use this bash script to generate NGINX server block files for domains, sub-domains, load-balancing, and other common tasks after a fresh system setup.

</h1>How it works</h2>
Once executed, the script performs the following tasks:
<ol>
<li>Verifies NGINX installation</li>
<li>Verifies NGINX configuration files/directories and detects conflics</li>
<li>Generates server configuration based on user input</li>
<li>Create and save configuration files based on the repos/NGINX installation</li>
</ol>


<h2>How to use it</h2>

You can either clone this repos to your local workstation/server or download the Script file and run it.

```
sh nginxse.sh
```

Or 

```
chmod +x nginxse.sh
./nginxse.sh
```

You will be promped to provide the settings you might need.

A short demo is available on <a href="http://imgur.com/a/xL7rY">imgur</a>


<h2>Supported distros</h2>
Tested on Debian, CentOS, Fedora, and ubuntu.
It should work fine with any GNU/Linux with a clean nginx install.


<h2>Contribute</h2>

Please don't hesitate to help with your feedback or if you want to help to improve it, feel free to fork.

<h2>LICENSE</h2>
If you are too lazy to read the license, it basically tells you to not modify and redistribute this code unless you are planning to keep it as a free software AND mention the original author.


This software is GPL licensed. The work based off of it must be released as open source.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

