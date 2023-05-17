# MapmarkerTemplate
A combination of resourcepack and datapack to allow creator to place objective marker.

## Usage
Install the datapack  
```
function mapmarker:install
```  
  
Summon the marker  
```
function mapmarker:summon/0
```  
  
Change the scale of the marker  
```
# control the current scale with its score
execute as @e[tag=entity.mapmarker] run scoreboard players set @s entity.mapmarker.scale 4
execute as @e[tag=entity.mapmarker] run function mapmarker:update_scale/do
```
  
Apply variant
```
execute as @e[tag=entity.mapmarker] run function mapmarker:apply_variant/0
```
  
Uninstall the datapack  
```
function mapmarker:uninstall
```  
