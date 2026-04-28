I want to create a WhatsApp bot that I can put inside our chess group message. When someone elaves n unstructured game result (e.g. "Gery (black) beats Mason") the bot aprses the message, commits the server action of creating a game (submitted by wahtsappbot rather than user UUID) and then responds with the server action result s(elo change).

## Constraints

- Free — no paid services
- No setting up a dedicated phone number (use a Google Voice number to avoid risking a personal number)
## Possible Options

Baileys - typescript websocket that connects via linked device

Whatsapp-web.js - connects via linked device and puppeteer (headless chrome) not actively maintaines anymore

Meta CLoud A:I - Require meta bbuinsess verification, didicated phone number, and webhook infrastructre

Twilio - paid per message


