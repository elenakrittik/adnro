use std "path add"

print "Initializing folder structure"
mkdir ~/.config
mkdir ~/.config/helix
mkdir ~/.cargo/bin
mkdir ~/.local/bin
mkdir ~/Development
mkdir ~/Development/Repos
mkdir ~/Development/Projects
mkdir ~/Development/Projects/Python
mkdir ~/Development/Projects/Rust

# TODO: run only if on linux
print "Installing pacman packages"
sudo pacman -Syu "archlinuxarm-keyring" "base" "base-devel" "fontconfig" "github-cli" "helix" "man-db" "mold" "moreutils" "onefetch" "pacman-contrib" "patchelf" "sha3sum" "tree" "wget" "zola" "python" "python-pipx" "git" "rustup" "fzf" --needed

print "Logging into GitHub"
gh auth login

print "Installing pipx packages"
pipx install pdm ruff ruff-lsp

print "Installing Rust"
rustup toolchain install nightly --profile minimal
rustup component add rust-src
rustup component add rust-analyzer
rustup component add clippy
rustup component add rust-docs
rustup component add rustfmt

print "Installing Rust-based tools"
# TODO: ensure ln is cross-platform
ln --symbolic (rustup which "rust-analyzer") ~/.cargo/bin
# TODO: different url for windoge
curl -L --proto '=https' --tlsv1.2 -sSf "https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh" | bash
cargo binstall du-dust hyperfine ra-multiplex ripgrep starship tokei cargo-audit cargo-nextest cargo-shear zoxide bat

print "Installing Volta"
# TODO: install volta from binary if on windows
git clone "https://github.com/volta-cli/volta" ~/Development/Repos/volta
cargo install --path ~/Development/Repos/volta

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

print "Building helix grammars"
helix --grammar fetch
helix --grammar build

print "Done!"
