use std *

print "Initializing folder structure"
mkdir ~/Development
mkdir ~/Development/Repos
mkdir ~/Development/Projects
mkdir ~/Development/Projects/Python
mkdir ~/Development/Projects/Rust

print "Installing pacman packages"
sudo pacman -Syu "archlinuxarm-keyring base base-devel fontconfig github-cli
                 helix man-db mold moreutils onefetch pacman-contrib patchelf sha3sum
                 tree wget zola python python-pipx git rustup fzf --needed"

print "Logging into GitHub"
gh auth login

print "Installing pipx packages"
pipx install pdm ruff ruff-lsp

print "Installing Rust"
rustup toolchain install nightly --profile default "-c rust-src
                                                    -c rust-analyzer
                                                    -c clippy
                                                    -c rust
                                                    -c rust-docs
                                                    -c rustfmt"


print "Installing Rust-based tools"
mkdir ~/.cargo/bin
path add ~/.cargo/bin
ln --symbolic (rustup which rust-analyzer) ~/.cargo/bin
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall "du-dust hyperfine ra-multiplex ripgrep starship tokei cargo-audit
                cargo-nextest cargo-shear zoxide bat"
mkdir ~/.nuscripts/
echo "zoxide init nushell | save -f ~/.nuscripts/zoxide.nu" | save --append $nu.env-path
echo "source ~/.nuscripts/zoxide.nu" | save --append $nu.config-path
echo "starship init nu | save -f ~/.nuscripts/starship.nu" | save --append $nu.env-path
echo "use ~/.nuscripts/starship.nu" | save --append $nu.config-path

print "Installing Volta"
git clone https://github.com/volta-cli/volta ~/Development/Repos/volta
cargo install --path ~/Development/Repos/volta
path add ~/.volta/bin

print "Installing Volta-based tools"
volta install node@latest pyright@latest

print "Setting up Python projects"
cd ~/Development/Projects/Python
gh repo clone DisnakeDev/disnake
cd disnake
pdm install -G:all
pdm run pre-commit install --install-hooks

print "Setting up Rust projects"
cd ~/Development/Projects/Rust
gh repo clone astral-sh/ruff
gh repo clone oxc-project/oxc
gh repo clone gdtk
cd gdtk
cargo fetch

print "Copying configs"
mkdir ~/.config/
mkdir ~/.config/helix
wget https://gist.githubusercontent.com/elenakrittik/6e658b8b4b733818604447f7aea9aed9/raw/bfef11a3607a3ac2a6c18db81fb80b2e6404c345/hxconfig.toml -O ~/.config/helix/config.toml
wget https://gist.githubusercontent.com/elenakrittik/6e658b8b4b733818604447f7aea9aed9/raw/bfef11a3607a3ac2a6c18db81fb80b2e6404c345/hxlangs.toml -O ~/.config/helix/languages.toml
helix --grammar fetch
helix --grammar build
wget https://gist.githubusercontent.com/elenakrittik/6e658b8b4b733818604447f7aea9aed9/raw/8476f0a89ef040a93a1df054a580afaf66234395/starship.toml -O ~/.config/sharship.toml

print "Setting up aliases"
echo "alias hx = helix" | save --append $nu.config-path
echo "alias gta = git add ." | save --append $nu.config-path
echo "alias gcm = git commit -am" | save --append $nu.config-path
echo "alias gpl = git pull" | save --append $nu.config-path
echo "alias gps = git push" | save --append $nu.config-path
echo "alias gsw = git switch" | save --append $nu.config-path
echo "alias gst = git status" | save --append $nu.config-path

print "Enjoy your backdoor, soygrammer."
