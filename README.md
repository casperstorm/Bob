Bob
==========
A Tarsnap OS X GUI client.

Tarsnap is a secure online backup service. Bob provides a GUI interface for managing Tarsnap backups.

Bob is work in progress and hence we take no responsibility for lost data.

## Dependencies
- [Tarsnap](http://www.tarsnap.com/)
- [Tarsnapper](https://github.com/miracle2k/tarsnapper)

## Setup

Install [Tarsnap](http://www.tarsnap.com/) by either compiling it your self or through `Brew`:

	brew install tarsnap

After that, follow the four steps on their [Getting Started](http://www.tarsnap.com/gettingstarted.html).
	
	
Then you need to install [Tarsnapper](https://github.com/miracle2k/tarsnapper), e.g. with `easy_install`

	easy_install tarsnapper

After the installation of both Tarsnap and Tarsnapper you can enjoy Bob by compiling or downloading the latest [binary](https://github.com/casperstorm/Bob/releases).

## Screenshot

![](https://raw.githubusercontent.com/casperstorm/casperstorm.github.io/master/img/bob.png)

## Roadmap
* ~~Include folders~~
* ~~Desktop notifications~~
* ~~Automatic backups~~
* ~~Log view~~
* ~~Start on launch~~
* ~~Status bar icon~~
* Define generations in preferences
* Remove Tarsnapper dependency
* Bundle compiled version of Tarsnap (Optional for user)
* Sparkle integration by Andy Matuschak
* Exclude folders
* Exclude pattern match
* List backups
* Remove backup
* Browse through files in a backup
* Recover files and folders in a backup
* Application icon
* Show activies and balance for Tarsnap account
* Alert when balance is low
* Easy to deposit money on Tarsnap account
* Generate Tarsnap key file wizard
* Write code and be happy

## License

MIT