# Enemy Variation Data

Entries of the `enemy_variations` level JSON field.
Can be `null` in which a default enemy will be spawned.

All the data fields provided are optional.

- `speed_multiplier` : Multiplies the enemy’s speed
	- example: `2.4533` would be 2.4533x regular speed
	
- `graphic` : Changes what the enemy looks like (its sprite/image) and will look for the asset in `images/enemies/`
	- `jerry` would look for `images/enemies/jerry.png`
	
- `variation_chance` : Overrides the chance of the variation being selected
	- example: `23.5` would be a 23.5% chance
	
- `present` : Controls what the base enemy variation data is
	- example: `super-saiyan` would look for `data/enemy_variation_presents/super-saiyan.json` and use that as the present if found
