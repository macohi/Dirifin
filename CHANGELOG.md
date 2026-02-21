# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
This project adheres to [a custom version format](https://github.com/macohi/Dirifin/blob/main/docs/VERSION_FORMAT.md)

## [3.00] - 2/27/2026

- [DESKTOP] `api_version` should be 3.0+ for mods to not be labelled as outdated

### Added

- Added `settings` field to level JSONs
- Added Level BGs in the BG of the level select
- **ADDED ENEMY VARIATIONS!**
	- They work via the new `enemyVariations` field in level JSONs. And you can use the new levels as an example as to how they work.
- Added Levels 4, 5, and 6

### Changed

- Level BGs automatically scale to fit based on width and height now
- Changed directory of the (now default) enemy asset to `assets/images/enemies/default` (this is where all enemy assets will go obv)

## [2.21] - 2/20/2026

### Fixed?

- Crashes when shooting enemies too fast

## [2.20] - 2/20/2026

### Added

- Added Option to shoot with the directionals instead of `gameplay_fire`
	- Added SWD Highscores
- **CONTROLS REMAPPING**
- **OPTIONS MENU**

### Fixed

- Fixed the back keybind not allowing you to leave the level select

### Removed

- All support for the "highscore" save field has been cut off and if your save is from 1.00 to 1.21 you will lose your level 1 high score


## [2.10] - 2/18/2026

### Fixed

- [DESKTOP] `api_version` should be 2.0+ for mods to not be labelled as outdated (this is a fix cause the change was intended for 2.00)

### Added

- [DESKTOP] Discord RPC Support


## [2.00] - 2/18/2026

### Added

- **ADDED LEVEL 3!!**
- **ADDED NEW BG SONG: "MASTERY"**
- **ADDED NEW BG SONG: "INVASION"**
- [DESKTOP] Log files are generated when running the game now
- You can press "R" on any state to go to the github issues page

### Fixed

- Gameover sending you back to level 1

### Changed

- The song list updates when the song list text file updates now (including when mods update it)

## [2.00 Pre-Release 1] - 2/17/2026

### Added

- [DESKTOP] **ADDED MOD SUPPORT**
	- `api_version` should be 1.0+ for the mod to not be labelled as outdated
	- **WITH A MOD MENU!!!!!!!**
	- Just asset replacement and addition stuff right now, no scripts, sry
- **ADDED LEVEL 2!!**
- **ADDED LEVEL SELECT!**
- Added support for level JSONS (`assets/data/levels/_.json`) to change gameplay values
- You can leave the credits menu now via the back key (ESCAPE)
- Added level to the score text
- Added Panning and Pitching depending on what direction an enemy spawns in

### Fixed

- Fixed blank credits lines being added as text

### Removed

- Removed `_-goes-here.txt` files
- Removed bullet sprite

### Changed

- Updated Level 1 BG
- It's possible to append credits to the credits list via a mod now
- BG Tracks are now softcoded and moddable via `assets/data/songs.txt`
- The `highscore` save field has been removed and replaced with `highscores` (your highscore for level1 will persist however)
- Sized up score and highscore text in gameplay

## [1.21] - 2/17/2026

### Fixed

- Fixed Enemies spawning in the same direction not being a 10% chance

### Added

- Added Application Icon
- Added BG to Level 1

### Changed

- Changed "Play" to "Level 1" in the Main Menu

## [1.11] - 2/17/2026

### Removed

- Disabled / Removed Lost Focus Screen ([#3](https://github.com/macohi/Dirifin/pull/3))

### Added

- You can press the back keys to leave to the main menu in the game over
- Github Contributors to credits

### Changed

- Credits format has changed slightly

## [1.10] - 2/16/2026

### Added

- **CREDITS... MENU?**
- **MAIN MENU**
- You can leave to the main menu from gameplay in the pause menu via the back key
- "back" control

### Changed

- Moved Version Text to Main menu
- Direction arrow sprite has been updated

### Fixed

- Fixed Off-Centered Arrows ([#1](https://github.com/macohi/Dirifin/issues/1))

## [1.00] - 2/16/2026

### Added

- BACKGROUND TRACK : "dungeon drif"
     - BG tracks play every once and awhile
- The ability to pause
- Little animation before true death
- little anim kinda transition thingy with enemies when they spawn and now they do like a bouncy kinda thing when they spawn
- HIGH SCORE!
- SAVE FILE
- Enemy Direction... animations? Do you wanna call it that?
- Player Sprite
- SOUND EFFECTS!
- Bullet Sprite

### Changed

- Enemy is now SLIGHTLY brighter
- Enemies spawning in the same direction after spawning multiple around the same time is a rarer chance now (10% chance)
- Bullets now fade in half the time
- The bullet sprite is scaled up

### Fixed

- The cursor is now invisible
- Enemies spawned later are now behind enemies spawned earlier

## [1.00 Pre-Release 1] - 2/16/2026

Technically the inital release, no changes in the changelog
