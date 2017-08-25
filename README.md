# Konfiguration von Servern via Ansible

## Prerequesites

Get a Raspberry Pi with Raspbean. The easiest way is to follow the [Raspberry Pi Guides](https://www.raspberrypi.org/help/). Probably the easiest option is to use [NOOBS Lite](https://www.raspberrypi.org/downloads/noobs/)
If you want to use the Pi as a backup server, you might want to store more data on it than fits on the SD card. You could then for example buy an exernal disk and connect it via USB to your Pi

- Hard drives with no separate power supply may sometimes consume too much power from the Pi, especially when accellerating the disk. Alternatives are hard drives with separate power supply or SSDs.

It depends on the reliability of your power source if you should use a uninteruptible power supply (UPS). Some have even a high current USB port (TODO: StromPi 2, test with current-hungry hdd).

## Installation

1. In the Raspbian desktop environment,
    open a terminal—for example via Ctrl+Alt+T
1. In that terminal, run the following commands

        . <(curl https://tiny.cc/rpi-setup-dev -sSfL)

## Contribute

1. Clone this repository
1. Install [yarn](https://yarnpkg.com/en/) and run:

       yarn

1. Install `python-pip` and run:

       pip2 install ansible-lint
