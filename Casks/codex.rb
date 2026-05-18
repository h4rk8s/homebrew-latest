cask "codex" do
  version "0.131.0"

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

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", staged_path.to_s],
                   sudo: false
  end
end
