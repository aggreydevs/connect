{
  description = "A development environment for working with SoundAdvice projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            libsecret
            nodejs_24
            pnpm
          ];

          shellHook = ''
            echo "Loading secrets from keyring..."

            OPENAI_API_KEY=$(secret-tool lookup service openai key api 2>/dev/null || true)
            ANTHROPIC_API_KEY=$(secret-tool lookup service anthropic key api 2>/dev/null || true)

            if [ -n "$OPENAI_API_KEY" ]; then
              export OPENAI_API_KEY
            else
              echo "WARNING: OPENAI_API_KEY not found in keyring"
            fi

            if [ -n "$ANTHROPIC_API_KEY" ]; then
              export ANTHROPIC_API_KEY
            else
              echo "WARNING: ANTHROPIC_API_KEY not found in keyring"
            fi
          '';
        };
      }
    );
}
