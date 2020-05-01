# BLETemplate

A template iOS app using the CoreBluetooth, SwiftUI and Combine frameworks.

It detects a specific peripheral set up using a Raspberry Pi. It uses a Write service to set a timer to play some sounds after a given number of minutes. And a Notify service to show if a timer is currently set or not.

The Python files are for setting up a BLE peripheral to play sounds, I used a raspberry Pi.

## Environment information

### For the BLE Peripheral

Used Raspberri Pi 4 Model B

Raspbian version 10 (buster)

Python version 3.7.3

Node version 10.15.2

npm version 5.8.0

**Python dependencies:**

bluetoothctl version 5.50 (check your version first, it comes with Raspbian)

mutagen version 1.44.0

**Node dependencies:**

play-sound version 1.1.3 (You'll probably want to run a standalone example to check if play-sound will work properly with your default audio player)

### For the iOS App

Xcode 11.3.1