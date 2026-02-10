# Agent Guidelines for Dotfiles Repository

This is a Nix/NixOS/nix-darwin dotfiles repository managing system and user configurations across WSL (NixOS) and macOS (nix-darwin) systems.

## Build/Test/Lint Commands

This repository contains infrastructure configuration, not application code. There are no traditional build/test/lint commands.

**Validation commands:**
- `nix flake check` - Validate flake outputs and run checks
- `nixfmt flake.nix` - Format Nix files (if nixfmt is available)
- `nix eval .#nixosConfigurations.wsl.config.system.build.toplevel --dry-run` - Dry-run WSL build
- `darwin-rebuild check --flake .#macbook` - Check macOS configuration (on macOS only)

**Apply changes:**
- `sudo nixos-rebuild switch --flake .#wsl` - Apply WSL configuration
- `darwin-rebuild switch --flake .#macbook` - Apply macOS configuration

## Code Style Guidelines

### Nix Language Conventions

- **Formatting**: Use 2-space indentation (consistent with existing files)
- **Line length**: Keep lines under 100 characters when possible
- **Attribute sets**: Use `rec` only when necessary for self-reference
- **Function arguments**: Prefer explicit arguments over `...` when possible
- **Let bindings**: Group related bindings together with blank lines between groups

### File Structure

```
.
├── flake.nix          # Entry point - defines outputs for all systems
├── home/              # Home-manager configurations
│   ├── common.nix     # Shared user config (packages, git, zsh, nvim)
│   └── darwin.nix     # macOS-specific user config (imports common.nix)
└── hosts/             # System-level configurations
    ├── wsl/           # NixOS WSL configuration
    │   └── default.nix
    └── macbook/       # nix-darwin configuration
        └── default.nix
```

### Naming Conventions

- **Variables**: Use `camelCase` for local variables (e.g., `baseDir`, `specialArgs`)
- **Functions**: Use descriptive names for let bindings
- **Configuration names**: Use lowercase with hyphens for hostnames (e.g., `wsl`, `macbook`)
- **User variable**: Reference user via `user` parameter (set in `specialArgs`)

### Imports and Dependencies

- **Explicit imports**: List all imports explicitly at the top of files
- **Special arguments**: Pass `specialArgs` to share the `user` variable across modules
- **Follows**: Use `inputs.<name>.follows` to minimize duplicate dependencies

### Error Handling

- **Assertions**: Use `lib.asserts` for validation when needed
- **Defaults**: Provide sensible defaults with `lib.mkDefault` or `lib.mkForce` when overriding
- **Optionals**: Use `lib.optionals` and `lib.optional` for conditional lists

### Git Configuration

- **SSH signing**: All commits must be signed with SSH key
- **Default branch**: Use `main` as default branch
- **User**: `erechorse <erechorse@gmail.com>`
- **Allowed signers**: Configured in `~/.ssh/allowed_signers`

### Neovim Configuration

- Use Lua for configuration (set via `extraLuaConfig`)
- 2-space indentation, expand tabs
- Enable line numbers and relative line numbers
- Enable termguicolors

### Zsh Configuration

- Use oh-my-zsh with robbyrussell theme
- Enable vi-mode plugin
- Enable autosuggestion and syntax highlighting
- Standard alias: `ll` = `ls -l`

## Important Notes

- Always check both `home/` and `hosts/` directories when making changes
- macOS-specific packages use `brewCasks` overlay for GUI applications
- WSL uses `nixos-wsl` module for Windows integration
- SSH agent socket is managed by Bitwarden Desktop
- State versions: NixOS `25.05`, Home Manager `26.05`, Darwin `6`

## Testing Changes

Before applying to live systems:
1. Run `nix flake check` to validate syntax
2. Review the diff with `git diff`
3. Test on appropriate system (WSL or macOS)
4. Keep backups of working configurations
