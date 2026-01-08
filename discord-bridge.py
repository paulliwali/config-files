import os
import discord
import subprocess
from discord.ext import commands

# --- CONFIGURATION ---
# IMPORTANT: Replace these with your actual values before running
TOKEN = os.environ.get("DISCORD_BOT_TOKEN", "YOUR_DISCORD_BOT_TOKEN_HERE")
CHANNEL_ID = int(os.environ.get("DISCORD_CHANNEL_ID", "0"))  # Replace with your Channel ID (integer)
TMUX_SESSION = "claude"          # The session name we will control

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print(f"✅ Bridge Online: {bot.user}")

@bot.event
async def on_message(message):
    if message.author.bot or message.channel.id != CHANNEL_ID:
        return

    content = message.content.strip()

    # --- 1. SPECIAL COMMANDS ---
    cmd_map = {
        "!screen": "CAPTURE",
        "!up": "Up",       "!u": "Up",
        "!down": "Down",   "!d": "Down",
        "!left": "Left",   "!l": "Left",
        "!right": "Right", "!r": "Right",
        "!enter": "Enter", "!e": "Enter",
        "!yes": "y",       "!y": "y",
        "!no": "n",        "!n": "n",
        "!esc": "Escape",
        "!tab": "Tab",
        "!bs": "BSpace",   # Backspace
        "!c": "^C"         # Ctrl+C (Cancel)
    }

    lower_content = content.lower()

    # Handle !screen command
    if lower_content == "!screen":
        try:
            # Capture last 20 lines
            output = subprocess.check_output(
                ["tmux", "capture-pane", "-p", "-t", TMUX_SESSION, "-S", "-20"]
            ).decode("utf-8", errors="ignore")
            
            # --- THE FIX: SMART TRUNCATION ---
            # Discord limit is 2000 chars. We reserve 100 chars for the ``` formatting.
            if len(output) > 1900:
                # Keep the LAST 1900 characters (so you see the bottom of the screen)
                output = f"... (truncated top) ...\n{output[-1900:]}"
            
            if not output.strip():
                output = "[Terminal is empty or session not found]"
                
            await message.channel.send(f"```\n{output}\n```")
        except Exception as e:
            await message.channel.send(f"❌ Error: {e}")
        return

    # Handle Navigation Keys
    if lower_content in cmd_map:
        key = cmd_map[lower_content]
        # If it's a special key like ^C, we handle it differently if needed,
        # but tmux send-keys accepts C-c or ^C usually.
        # For simple keys:
        os.system(f"tmux send-keys -t {TMUX_SESSION} {key}")
        await message.add_reaction("🕹️")
        return

    # --- 2. TEXT & NUMBERS INPUT ---

    # Sanitize inputs (escape single quotes for bash)
    safe_content = content.replace("'", "'\\''")

    # LOGIC:
    # If the user types a number like "1", "2", "3", we send it, then Enter.
    # This works for 99% of CLI menus.

    os.system(f"tmux send-keys -t {TMUX_SESSION} '{safe_content}'")
    os.system(f"tmux send-keys -t {TMUX_SESSION} Enter")

    await message.add_reaction("✅")

bot.run(TOKEN)
