NOTE: SCRIPTS SHOULD ONLY GET OTHER SCRIPTS' VARIABLES, DO NOT SET THEM
## player.gd
### other nodes
- potions_parent_node: func attack

### variables
#### var can_attack
true when the player can attack, false otherwise
setters:
- func attack: can_attack is set as false right after the player successfully attacks
- func _on_attack_cooldown_timeout: can_attack is set as true after the attack cooldown timer ends
getters:
- func attack: player can only attack when the attack action is just pressed and if can_attack is true

# THINGS TO CHANGE
- player func _on_hurt_box_area_entered(): sets heart layer node's health
- player func _on_coin_collection_area_entered(): sets coin.collected

# THINGS TO KNOW
- player var can_hurt deleted
