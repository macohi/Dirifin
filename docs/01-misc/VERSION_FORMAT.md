# Version Format

The game is using a custom version format cause why not, half inspired by Geometry dash's version system.

> [!NOTE]  
> Non Pre-Release version tags are saved as `_.__a`
>
> while Pre-Release version tags are saved as `_.__b#`
>
> for sorting reasons.

## Major versions

Major versions are big content updates, adding new levels or adding a new system.

Major versions reset the second version number to 00 and increment the first version number by 1.

### Example (existing) Versions

- `1.00`
- `2.00`

## Minor versions

Minor versions are small content updates, adding a QOL feature, or just some bonus content not initally planned.

Minor versions increment the second version number by 10.

### Example (existing) Versions

- `1.10`
- `1.21`
- `2.10`

## Patch versions

Patch versions are simple bug fix updates that add a missing feature, fix a broken feature or unintended side-effect.

Patch versions increment the second version number by 1.

### Example (existing) Versions

- `1.11`

## Pre-Release versions

Pre-Release versions are versions that are released before a major (or maybe a big minor) update, intended to test the update before a release.

Pre-Release versions add "Pre-Release #" to the end of the version number.

### Example (existing) Versions

- `1.00 Pre-Release 1`
- `2.00 Pre-Release 1`
