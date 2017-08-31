# Requirements

This document shall keep track of next steps or ideas, primarily in the form of user stories to focus on usefull things.

## (Continuously) realized

- As a user which does not know much about Unix, cryptography and such, I don't want to spend much time learning these things before I can use my server, because I have better things to do.
- As a user I want to have clear instructions what I could to do, as I do not have much time.
- As a user I want to be comprehensible argumentations why something I could trust that solution.
- As a user I want to have a private cloud.
- As a user I want a system with a low total cost of ownership, because I want to save money.
- As a user I don't want to be confronted by a mergetool when there are no differences, because the other case would be annoying.

## Backlog

- As a user I don’t want to rely on tiny.cc, because it does not seem so reliable which may lead to installation difficulties. Instead I want to depend only on a single trustworthy service like GitHub, for example.
- As a user I only want to have a stable setup. As a developer or power user I want to test the newest things. So I would be convenient if the default installation procedure would employ a release branch (name `release`) whereas it should also be possible to check out a dev branch (name `dev`).
- As a user I want to use [nsupdate.info](https://www.nsupdate.info/) to setup DynDNS to get a domain name, because it is recommended by [PRISM Break](https://prism-break.org/en/projects/nsupdateinfo/).
- As a user I want the homepage and later services secured with TLS to prevent hackers sniffing my data.
- As a user I want a fixed domain for my server to enable easy access from the internet.
- As a user I want to have a simple status homepage under a fixed domain which proves that the server is online and that TLS works, because I want to know if the system could work in principal if I configure further services later.
- As a user I want to know how the expected system costs, because I want to compare it to other existing services before I invest in this unpopular solution.
    - Sub tasks
        - Collect information about the cost of the Pi and accessories. Document it on the page (remind that one possibly has some of the accessories at hand).
        - Collect information about the long term reliability of the Raspberry Pi and document the reliability findings in the repository
            - est. effort: 3 hours

## Options

- As a user I want to have a custom image because I don't want to typewrite commands in a terminal to get started (I've maybe never used a terminal before, so I feel uncertain).
    - Tasks
        - Create custom Raspbian image via [PiBakery](http://www.pibakery.org/).
- As a user I want to have a graphical application which allows me to select the services I want, because maybe I don’t want to install everything.
