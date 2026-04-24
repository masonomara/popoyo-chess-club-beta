# ELO Rating System

## The Formula

Expected score for a player is calculated as:

E = 1 / (1 + 10 ^ ((opponent rating − player rating) / 400))

New rating = old rating + K × (actual score − expected score)

Actual scores: win = 1.0, draw = 0.5, loss = 0.0.

When two players are equal, each has an expected score of 0.5. Every 400-point gap shifts the expected score by roughly 90% — from about 0.1 to about 0.9.

Example: Player A (1500) beats Player B (1600).

E_A = 1 / (1 + 10^(100/400)) ≈ 0.36. With K=20, Player A's new rating is 1500 + 20 × (1 − 0.36) = 1512.8. Player B's new rating is 1600 + 20 × (0 − 0.64) = 1587.2.

## K-Factor

K controls how much a single result can move a rating. Higher K means faster movement; lower K means more stability.

New and provisional players (typically the first 10–30 games) use K=40, so ratings converge to true skill faster. Established players use K=20–25, balancing stability with responsiveness. Elite players (ever rated 2400+) use K=10, protecting high ratings from large swings.

FIDE standards: K=40 for new players until 30 rated games, K=20 for established players, K=10 for players ever rated 2400+.

In a small pool with infrequent play, a slightly higher K — say, 25 instead of 20 — helps ratings self-correct faster given the smaller sample sizes.

## Starting Rating

1500 is the conventional starting point used by FIDE and most implementations. It places a new player at the midpoint of the scale, with equal expected probability against another new player.

## Draws

Both players receive an actual score of 0.5. The formula handles this naturally. A draw against a stronger opponent is a rating gain — you exceeded expectations. A draw against a weaker opponent is a rating loss — you underperformed. A draw against an equal opponent changes nothing.

## Color Bias

White scores roughly 54% historically across all levels of chess, equivalent to about a 35-point rating advantage. Standard ELO ignores this — the formula is color-blind. The options are to ignore it entirely, adjust the expected score by adding 35 points to White's effective rating in the calculation, or track color per game without adjusting ratings and try to balance color assignments over time. At recreational and club level, ignoring color bias is standard and acceptable.

## Time Controls

Different time controls test different skills. Most serious implementations maintain separate rating pools: bullet (under 3 min), blitz (3–10 min), rapid (10–60 min), and classical (60+ min). A typical player may have a 200–300 point gap between their blitz and classical ratings. For small pools, a single unified pool is a reasonable tradeoff — provided time control is tagged on every game for potential future separation.

## Game Ordering and Recalculation

Each game uses a player's rating at that moment in sequence — order matters.

Games must be processed in chronological order of when they were played, not when they were entered. Inserting a game out of order requires recalculating all subsequent ratings from that point forward. Editing or deleting a past game requires the same full recalculation from that game's position. Both `game_date` (when played) and `entered_at` (when recorded) should be stored separately.

## Provisional Players

A player's first N games — typically 10–30 — are considered provisional. The initial 1500 may not reflect true skill. The standard approach is to apply a higher K (40) during the provisional period and lower it once the player is established, display a visual indicator until the threshold is crossed, and track `games_played` per player to automate the K transition.

## Edge Cases

Very lopsided ratings (say, 2000 vs. 800) are handled naturally by the formula: a huge upset produces a large swing, and an expected result produces near-zero change. Forfeits and no-shows score as a loss for the forfeiting player (actual score = 0). Unplayed or void games are removed without rating impact if no result was recorded. Duplicate entries are resolved by deleting one and recalculating from that point. New players joining mid-season start at 1500 with the higher provisional K.
