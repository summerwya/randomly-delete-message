import { Client, Events, GatewayIntentBits, Partials } from "discord.js";

const client = new Client({
    intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages],
    partials: [Partials.Message]
});
client.on(Events.MessageCreate, async message => {
    if (message.author.id !== process.env.TARGET) return;
    try {
        if (Math.floor(Math.random() * parseInt(process.env.CHANCE!)) !== 1) return;

        console.log(`Deleted message ${message.id}`);
        await message.delete();
    } catch(e) {
        console.warn(`Couldn't delete message ${message.id}`, e);
    }
});
client.once(Events.ClientReady, readyClient => console.log(`Logged in as ${readyClient.user.tag}`));
client.login(process.env.DISCORD_BOT_TOKEN);