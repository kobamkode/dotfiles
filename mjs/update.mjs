#!/usr/bin/env zx

echo(chalk.bgYellow.black(`\n  Updating system  `))
const update = await $`sudo apt-get update`
echo(update)
const upgrade = await $`sudo apt-get upgrade -y`
echo(upgrade)

echo(chalk.bgYellow.black(`\n  Updating mise  `))
await $`mise up`

echo(chalk.bgYellow.black(`\n  Updating flatpak  `))
const flatpak = await $`flatpak update -y`
echo(flatpak)
