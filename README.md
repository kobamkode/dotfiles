# Dotfiles

My Fedora i3wm dotfiles

## Usage

- make sure git is installed
- clone this repo
- inside dotfiles dir, make `install.sh` executable
- run `./install.sh` to start packages installation

## Manual Installation

### Evremap

```sh
	cd dotfiles/evremap
	cargo build --release
	sudo cp target/release/evremap /usr/bin/evremap

	# Check `logitech-wave-keys.toml` device with [1]. Update the device in toml file if different.
		
        sudo cp ../logitech-wave-keys.toml /etc/evremap.toml
	sudo cp ../evremap.service /usr/lib/systemd/system/
	sudo systemctl daemon-reload
	sudo systemctl enable evremap.service
	sudo systemctl start evremap.service
```

[1] See [config](https://github.com/wez/evremap?tab=readme-ov-file#configuration) to setup.
