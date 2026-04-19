# [Project Name] Goal

> Budget 5–10 minutes. Aim for ~1000 words. The more specific, the better.
>
> Use the six core sections below as a template for a good `goal.md`. Feel free to include more or fewer sections — some projects demand additional ones such as business rules, sample data, algorithms, or third-party integrations.
>
> Goals are open-ended. This is the most important step, but it can be written however you like. This is how it's structured to work well with the commands — not the only valid approach.

## Project Context (core)

What is this app, why does it need to exist, and what problem does it solve? What already exists? What's broken or missing from the current solution? What does the app need to do?

> _Example: A lightweight tool for restaurant managers to track daily inventory levels. Currently managed in a shared spreadsheet that breaks when multiple people edit at once. The app needs to let staff log counts per item, flag items below a threshold, and let managers see a daily summary — nothing more._

## User Roles (core)

Who uses the app? Describe each type of user, how they log in, what they can do in the app, what they cannot do, and what they are supposed to do. Include relevant account fields such as email, display name, avatar, etc.

> _Example:_
> _- **Admin** — created manually in Supabase; can create, edit, and delete all items and view all inventory logs; cannot delete other admins._
> _- **Staff** — signs up with email and password; can log inventory counts for their assigned location; cannot edit item definitions or view other locations._

## User Flows (core)

Flows describe what users are supposed to do. Each flow should be a step-by-step sequence of actions leading to a concrete outcome. User flows should cover all key use cases.

Start from what brings the user to the app or screen and end at the outcome — what changed in the database or UI.

> _Example — Staff logs an inventory count:_
> _1. Staff opens the app and lands on the inventory list for their location._
> _2. Staff taps an item row to open the count entry form._
> _3. Staff enters the current quantity and optionally adds a note._
> _4. Staff taps Submit — count is saved, item row updates to show new quantity and timestamp._
> _5. If the quantity is below threshold, the item is flagged red on the list._

## Screens (core)

Screens describe what users see — a description of what each screen looks like and what it's for. List every screen with all key UI elements: what data is shown, what actions are available. Describe non-obvious form fields, toggles, or input shapes when the UI has complexity that wouldn't be obvious from the screen name.

> _Example:_
> _- **`/` — Inventory List**: Shows all items for the user's location sorted by category. Each row: item name, current quantity, threshold, last-updated timestamp, flag indicator. Tapping a row opens the count entry form. Managers see a location switcher at the top._
> _- **`/items/[id]` — Count Entry Form**: Item name and current count shown at top. Number input for new quantity. Optional text field for notes. Submit button. Cancel returns to list without saving._
>
> _Field constraints:_
> _- Quantity: integer only, 0–9999, no decimals_
> _- Notes: free text, max 280 characters, optional_
> _- Location: single-select dropdown populated from the locations table_

## Success State (core)

2–3 concrete, observable things you can check to confirm the app is working — not "it feels right," but "staff submitted a count and the row updated in the list and in the Supabase table editor."

> _Example:_
> _- Staff submits a count → the item row immediately shows the new quantity and timestamp, and a new row appears in the `inventory_counts` table in Supabase._
> _- An item with quantity below threshold → the row is flagged red in the list and stays flagged after a page refresh._
> _- Admin deletes an item → it disappears from the inventory list, but its historical counts are still visible in the `inventory_counts` table with the item marked archived._

## Key Mutations (core)

Every important write to the database — create, update, or delete. For non-trivial operations that touch multiple tables or require atomicity, describe the full operation and it will become a Postgres function called via RPC. When in doubt, write it out — `/schema` will decide the right implementation.

> _Example:_
> _- Create inventory count (staff submits a quantity for an item)_
> _- Update item threshold (admin changes the low-stock alert level)_
> _- Create item (admin adds a new item to the inventory list)_
> _- Delete item (admin removes an item; cascades to all counts)_

## Business Rules (bonus)

Invariants and edge cases the system must enforce — things that would be bugs if violated.

> _Example:_
> _- A staff member can only submit one count per item per shift_
> _- Quantity cannot be negative_
> _- Deleting an item archives it rather than hard-deletes, so historical counts are preserved_

## Constraints (bonus)

Hard limits the system must respect.

> _Example:_
> _- Must work on mobile (staff use phones on the floor)_
> _- No email notifications — managers check the dashboard manually_
> _- All data scoped to a single organization; no multi-tenant support needed_

## Sample Data (bonus)

Representative rows showing what real data looks like and how it should be normalized. Useful for seeding and for validating the schema.

> _Example:_
> _- Item: `{ name: "Olive Oil (1L)", category: "Dry Goods", unit: "bottles", threshold: 5 }`_
> _- Count: `{ item_id: ..., quantity: 3, note: "found two in back storage", submitted_by: ..., submitted_at: "2024-01-15T14:32:00Z" }`_

## Algorithm (bonus)

If the app has a non-trivial calculation — scoring, ranking, matching, pricing — describe it precisely. Claude will implement it as a Postgres function.

> _Example:_
> _- ELO rating update: K=32, expected score = 1 / (1 + 10^((opponent\_rating - player\_rating) / 400))_

## Third-Party Integrations (bonus)

Any external services the app talks to — APIs, webhooks, storage, email, payments, etc.

> _Example:_
> _- Resend for transactional email (low-stock alerts to managers)_
> _- Cloudinary for item photo uploads_
