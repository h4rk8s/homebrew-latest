cask "codex" do
  version "0.147.0"

  on_arm do
    sha256 "17b2984eb22b607e3d0c25728252fc90f510e476bad39a6d9f45cdb1aa685432"

    url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-package-aarch64-apple-darwin.tar.gz"

    binary "bin/codex"
    binary "bin/codex-code-mode-host"
  end
  on_intel do
    sha256 "d91e59133daf923bc45d76e3da4af8ae9ef62a0231da18488da0cd573b6e9d63"

    url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-package-x86_64-apple-darwin.tar.gz"

    binary "bin/codex"
    binary "bin/codex-code-mode-host"
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
    FileUtils.ln_sf "/opt/homebrew/bin/codex-code-mode-host", version_dir/"codex-code-mode-host"
    current_link = standalone_dir/"current"
    current_link.delete if current_link.symlink? || current_link.exist?
    File.symlink(version_dir.basename.to_s, current_link)
  end
end
