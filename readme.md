# join

This is a serverside library for Garry's Mod that can be used to limit [team](https://wiki.facepunch.com/gmod/team) joining in a way that persists even when players leave and re-join, avoiding a common exploit to bypass traditional team join cooldowns.

## Examples

```lua
join.SetCooldown(TEAM_RED, 60)
```

This sets the join cooldown of the red team (whichever index that may be), in seconds. **By default, teams do not have a cooldown** - each team must have their cooldowns manually set.

```lua
join.Set(Entity(1), 30)
```

This sets the next time the player is permitted to join another team by the join library, **relative to** the current [RealTime](https://wiki.facepunch.com/gmod/Global.RealTime).

Because of this, join cooldowns are treated as real-world events, unaffected by the factors that normally affect [CurTime](https://wiki.facepunch.com/gmod/Global.CurTime).

```lua
join.Update(Entity(1))
```

This works identically to the previous example, except the time is determined and set automatically based on the player's last team. **This will fail if the player never joined a team since the level was changed.** Much like the next time players can join another team, the player's previous team will persist even if the player leaves and re-joins.

```lua
join.Check(Entity(1))
```

This quickly checks and returns whether a player is ready to join another team. In other words, it returns true if the player doesn't have a next join time assigned to them.

## License

This is licensed under the [DBAD License](license.md).
