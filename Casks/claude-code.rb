cask "claude-code" do
  version "2.1.144"

  on_arm do
    url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/#{version}/darwin-arm64/claude",
        verified: "storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
    sha256 "9886baa4ec4c455f86108464f121732193ee76e5dfceb031005f59f31276a5df"
  end

  on_intel do
    url "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/#{version}/darwin-x64/claude",
        verified: "storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/"
    sha256 :no_check
  end

  name "Claude Code"
  desc "Terminal-based AI coding assistant (latest channel)"
  homepage "https://www.anthropic.com/claude-code"

  binary "claude"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", staged_path.to_s],
                   sudo: false
  end

  zap trash: [
    "~/.cache/claude",
    "~/.claude.json*",
    "~/.config/claude",
    "~/.local/bin/claude",
    "~/.local/share/claude",
    "~/.local/state/claude",
    "~/Library/Caches/claude-cli-nodejs",
  ],
      rmdir: "~/.claude"
end
