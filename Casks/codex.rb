cask "codex" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.147.0"
  sha256 arm:   "17b2984eb22b607e3d0c25728252fc90f510e476bad39a6d9f45cdb1aa685432",
         intel: "d91e59133daf923bc45d76e3da4af8ae9ef62a0231da18488da0cd573b6e9d63"

  url "https://github.com/openai/codex/releases/download/rust-v#{version}/codex-package-#{arch}-apple-darwin.tar.gz"
  name "Codex"
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"

  livecheck do
    url :url
    regex(/^rust[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on :macos

  binary "bin/codex-homebrew", target: "codex"
  # Keep the host public for callers that launch it via HOMEBREW_PREFIX/bin.
  binary "bin/codex-code-mode-host"
  generate_completions_from_executable "bin/codex-homebrew", "completion", base_name: "codex"

  preflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", staged_path.to_s],
                   sudo: false

    # Preserve the canonical package entrypoint while avoiding stale macOS
    # execution assessments tied to that exact path. A hard link costs no
    # additional package space and remains inside the signed package layout.
    source = staged_path/"bin/codex"
    target = staged_path/"bin/codex-homebrew"
    if target.symlink? || (target.exist? && !File.identical?(source, target))
      raise "#{target} exists and is not the managed hard link"
    end

    File.link source, target unless target.exist?
  end

  postflight do
    standalone_dir = Pathname("~/.codex/packages/standalone").expand_path
    if standalone_dir.symlink? || (standalone_dir.exist? && !standalone_dir.directory?)
      raise "#{standalone_dir} exists and is not a managed directory"
    end

    standalone_dir.mkpath

    # Coordinate with the upstream standalone installer, which locks this file with lockf.
    File.open(standalone_dir/"install.lock", File::RDWR | File::CREAT, 0600) do |lock|
      lock.flock File::LOCK_EX

      homebrew_dir = standalone_dir/"homebrew"
      current_link = standalone_dir/"current"
      managed_links = {
        homebrew_dir/"codex"                => HOMEBREW_PREFIX/"bin/codex",
        homebrew_dir/"codex-code-mode-host" => HOMEBREW_PREFIX/"bin/codex-code-mode-host",
      }

      if !current_link.symlink? && current_link.exist?
        raise "#{current_link} exists and is not a symlink"
      end

      manages_current = !current_link.symlink? ||
                        current_link.readlink.to_s.match?(/\A(?:homebrew|brew-\d+(?:\.\d+)+)\z/)
      if manages_current
        if homebrew_dir.symlink? || (homebrew_dir.exist? && !homebrew_dir.directory?)
          raise "#{homebrew_dir} exists and is not a managed directory"
        end

        managed_links.each do |link, target|
          if link.symlink?
            raise "#{link} points outside Homebrew" if link.readlink != target
          elsif link.exist?
            raise "#{link} exists and is not a symlink"
          end
        end

        replacement_link = standalone_dir/".current.homebrew-#{Process.pid}"
        raise "#{replacement_link} already exists" if replacement_link.exist? || replacement_link.symlink?

        homebrew_dir.mkpath
        managed_links.each { |link, target| FileUtils.ln_sf target, link }

        begin
          File.symlink homebrew_dir.basename.to_s, replacement_link
          File.rename replacement_link, current_link
        ensure
          if replacement_link.symlink? && replacement_link.readlink == homebrew_dir.basename
            replacement_link.unlink
          end
        end
      end
    end
  end

  uninstall_postflight do
    standalone_dir = Pathname("~/.codex/packages/standalone").expand_path
    if standalone_dir.directory? && !standalone_dir.symlink?
      File.open(standalone_dir/"install.lock", File::RDWR | File::CREAT, 0600) do |lock|
        lock.flock File::LOCK_EX

        homebrew_dir = standalone_dir/"homebrew"
        current_link = standalone_dir/"current"

        current_link.unlink if current_link.symlink? && current_link.readlink == homebrew_dir.basename

        if homebrew_dir.directory? && !homebrew_dir.symlink?
          managed_links = {
            homebrew_dir/"codex"                => HOMEBREW_PREFIX/"bin/codex",
            homebrew_dir/"codex-code-mode-host" => HOMEBREW_PREFIX/"bin/codex-code-mode-host",
          }
          managed_links.each do |link, target|
            link.unlink if link.symlink? && link.readlink == target
          end
          homebrew_dir.rmdir if homebrew_dir.children.empty?
        end
      end
    end
  end

  zap rmdir: "~/.codex"
end
