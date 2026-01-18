#!/usr/bin/env python3
import os
import glob
import discord

TOKEN = os.environ.get("DISCORD_BOT_TOKEN")
if not TOKEN:
    print("ERROR: DISCORD_BOT_TOKEN environment variable not set")
    import sys
    sys.exit(1)
CONFIG_DIR = "/root/.claude-sessions"

# Try to load YAML to read existing configs
try:
    import yaml
    HAS_YAML = True
except ImportError:
    HAS_YAML = False

# Load existing configured channels
configured_channels = {}
if HAS_YAML and os.path.exists(CONFIG_DIR):
    for config_file in glob.glob(f"{CONFIG_DIR}/*.yaml"):
        try:
            with open(config_file, 'r') as f:
                config = yaml.safe_load(f)
                channel_id = config.get('discord_channel_id')
                repo_name = config.get('repo_name')
                if channel_id:
                    configured_channels[int(channel_id)] = repo_name
        except Exception as e:
            pass

intents = discord.Intents.default()
intents.guilds = True
client = discord.Client(intents=intents)

@client.event
async def on_ready():
    print(f"✅ Logged in as {client.user}")

    if configured_channels:
        print("\n⚙️  Currently configured sessions:")
        print("-" * 80)
        for channel_id, repo_name in configured_channels.items():
            print(f"  🔗 {repo_name:30} → Channel ID: {channel_id}")
        print()

    print("\n📋 Available Discord channels:")
    print("-" * 80)

    for guild in client.guilds:
        print(f"\n🏰 Server: {guild.name} (ID: {guild.id})")
        for channel in guild.channels:
            if isinstance(channel, discord.TextChannel):
                status = ""
                if channel.id in configured_channels:
                    status = f" ✓ [CONFIGURED: {configured_channels[channel.id]}]"
                print(f"  📝 #{channel.name:30} → ID: {channel.id}{status}")

    print("\n" + "=" * 80)
    print("Usage:")
    print("  - Create a new Discord channel for your repo")
    print("  - Copy the channel ID from the list above")
    print("  - Run: claude-session add")
    print("  - Enter the channel ID when prompted")
    print()
    if configured_channels:
        print("⚠️  Note: Channels marked with ✓ are already configured")
    print("=" * 80)

    await client.close()

client.run(TOKEN)
