execute store result score #temp.0 loy.value run data get entity @s item.tag.display.color

scoreboard players operation #temp.1 loy.value = #temp.0 loy.value
scoreboard players operation #temp.1 loy.value %= #mapmarker.scale.max loy.value
scoreboard players operation #temp.0 loy.value -= #temp.0 loy.value
scoreboard players operation #temp.0 loy.value += @s entity.mapmarker.scale

execute store result entity @s item.tag.display.color int 1 run scoreboard players get #temp.0 loy.value