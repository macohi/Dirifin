# Enemy Variation Data

Entries of the `enemyVariations` level JSON field.
Can be `null` in which a default enemy will be spawned.

All the data fields provided are optional.

- `speed_multiplier` : Multiplies the enemy’s speed
	- example: 2.4533 would be 2.4533x regular speed
	
- `graphic` : Changes what the enemy looks like (its sprite/image) and will look for the asset in `images/enemies/`
	- "jerry" would look for `images/enemies/jerry"
	
- `variation_chance` : Overrides the chance of the variation being selected
	- example: 23.5 would be a 23.5% chance
