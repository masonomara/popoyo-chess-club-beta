-- Delete all existing games
DELETE FROM games;

-- Insert 82 games from unstructured-games.md
-- player IDs: Austin=be9cd8ba, Gery=bc0c3ae8, Mason=7dd665f5, Top-Rob=41d449f6
-- submitted_by is always Mason (7dd665f5-c37d-4625-93d5-41882c377ec0)

INSERT INTO games (player1_id, player2_id, player1_color, result, game_date, time_control, time_control_category, submitted_by) VALUES

-- 4/12 (2 games)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-12 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Top-Rob
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'black', 'player1_win', '2026-04-12 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Top-Rob

-- 4/13 (7 games)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-13 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Gerry
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-13 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Top-Rob
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-13 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-13 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Mason
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-13 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Austin
('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-13 11:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Austin(black) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '2026-04-13 12:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Austin

-- 4/14 (12 games)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-14 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(black) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-14 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-14 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-14 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-14 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-14 11:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Austin
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'draw',        '2026-04-14 12:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry/Austin draw
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-14 12:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'draw',        '2026-04-14 13:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry/Top-Rob draw
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-14 13:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Top-Rob
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-14 14:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '2026-04-14 14:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Austin

-- 4/15 (13 games)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-15 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-15 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-15 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-15 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-15 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Austin
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-15 11:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '2026-04-15 12:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Austin
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-15 12:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-15 13:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '2026-04-15 13:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Austin
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-15 14:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-15 14:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-15 15:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason

-- 4/16 (7 games)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-16 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Top-Rob
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-16 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Top-Rob
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-16 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '2026-04-16 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(black) beats Austin
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-16 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-16 11:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-16 12:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(black) beats Mason

-- 4/17 (11 games)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-17 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Gerry
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-17 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Austin
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-17 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(black) beats Gerry
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-17 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Top-Rob
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-17 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-17 11:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-17 12:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-17 12:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry(white) beats Top-Rob
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-17 13:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Austin
('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-17 13:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Austin(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '2026-04-17 14:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Austin

-- 4/18 (5 games)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'draw',        '2026-04-18 09:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Gerry/Mason draw
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-18 09:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Mason(white) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-18 10:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-18 10:30:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-18 11:00:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- Top-Rob(black) beats Mason

-- 4/20 (5 games — times from chat, EDT = UTC-4)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-20 13:09:45+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 9:09 AM: Gerry(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-20 13:23:18+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 9:23 AM: Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-20 13:35:50+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 9:35 AM: Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-20 17:15:24+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 1:15 PM: Top-Rob(black) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-20 17:48:40+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 1:48 PM: Top-Rob(black) beats Gerry

-- 4/21 (4 games — times from chat, EDT = UTC-4)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-21 15:07:57+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 11:07 AM: Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-21 16:23:18+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 12:23 PM: Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-21 16:51:49+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 12:51 PM: Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-21 17:03:47+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 1:03 PM: Top-Rob(white) beats Mason

-- 4/22 (12 games — times from chat, EDT = UTC-4)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-22 12:56:45+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 8:56 AM: Top-Rob(white) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-22 13:34:54+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 9:34 AM: Gerry(white) beats Top-Rob
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-22 14:52:40+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 10:52:40 AM: Top-Rob(white) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-22 14:52:49+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 10:52:49 AM: Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-22 15:01:49+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 11:01 AM: Top-Rob(black) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '2026-04-22 15:22:00+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 11:22 AM: Gerry(white) beats Top-Rob
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-22 15:42:34+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 11:42 AM: Top-Rob(white) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '2026-04-22 20:07:37+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 4:07 PM: Top-Rob(white) beats Gerry
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '2026-04-22 20:27:02+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 4:27 PM: Top-Rob(black) beats Gerry
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'black', 'player1_win', '2026-04-22 20:58:19+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 4:58 PM: Gerry(black) beats Top-Rob
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-22 21:30:16+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 5:30:16 PM: Gerry(black) beats Mason
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-22 21:30:23+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 5:30:23 PM: Gerry(white) beats Mason

-- 4/23 (4 games — times from chat, EDT = UTC-4)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-23 16:03:22+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 12:03 PM: Top-Rob(white) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-23 16:21:18+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 12:21 PM: Top-Rob(black) beats Mason
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '2026-04-23 16:40:16+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'), -- 12:40 PM: Top-Rob(white) beats Mason
('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '2026-04-23 20:17:19+00', '10+0', 'rapid', '7dd665f5-c37d-4625-93d5-41882c377ec0'); -- 4:17 PM: Austin(black) beats Mason ("Rob A")
