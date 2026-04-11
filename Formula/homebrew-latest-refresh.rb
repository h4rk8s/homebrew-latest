class HomebrewLatestRefresh < Formula
  desc "Daily refresh service for the h4rk8s/latest tap"
  homepage "https://github.com/h4rk8s/homebrew-latest"
  url "file:///dev/null"
  version "1.0.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  def install
    (prefix/"bin").mkpath
  end

  service do
    tap_root = Pathname.new(__dir__).parent.realpath

    run [tap_root/"bin/refresh"]
    working_dir tap_root
    run_type :interval
    interval 21600
    environment_variables PATH: "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin",
                          HOMEBREW_LATEST_TAP_DIR: tap_root.to_s,
                          HTTP_PROXY: "http://127.0.0.1:6152",
                          HTTPS_PROXY: "http://127.0.0.1:6152"
    log_path Pathname.new(ENV["HOME"])/"Library/Logs/homebrew-latest-refresh.log"
    error_log_path Pathname.new(ENV["HOME"])/"Library/Logs/homebrew-latest-refresh.err.log"
  end
end
