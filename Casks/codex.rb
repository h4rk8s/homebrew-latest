cask "codex" do
  version "0.138.0"

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

    # remote-control daemon 需要 ~/.codex/packages/standalone/current/codex 这个固定路径
    # 用 symlink 指向 brew 二进制，避免再装一份 standalone
    standalone_dir = Pathname.new(Dir.home)/".codex/packages/standalone"
    version_dir = standalone_dir/"brew-#{version}"
    version_dir.mkpath
    FileUtils.ln_sf "/opt/homebrew/bin/codex", version_dir/"codex"
    current_link = standalone_dir/"current"
    current_link.delete if current_link.symlink? || current_link.exist?
    File.symlink(version_dir.basename.to_s, current_link)
  end
end
