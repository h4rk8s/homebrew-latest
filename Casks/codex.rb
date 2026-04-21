cask "codex" do
  version "0.122.0"

  on_arm do
    url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-aarch64-apple-darwin.tar.gz"
    sha256 :no_check
    binary "codex-aarch64-apple-darwin", target: "codex"
  end

  on_intel do
    url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-x86_64-apple-darwin.tar.gz"
    sha256 :no_check
    binary "codex-x86_64-apple-darwin", target: "codex"
  end

  name "Codex"
  desc "OpenAI's coding agent (latest channel)"
  homepage "https://github.com/openai/codex"

  conflicts_with cask: "homebrew/cask/codex"
end
