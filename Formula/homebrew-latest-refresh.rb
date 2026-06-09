class HomebrewLatestRefresh < Formula
  desc "Daily refresh service for the h4rk8s/latest tap"
  homepage "https://github.com/h4rk8s/homebrew-latest"
  url "file:///dev/null"
  version "1.0.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  def tap_root
    HOMEBREW_PREFIX/"Library/Taps/h4rk8s/homebrew-latest"
  end

  def user_home
    Pathname.new("/Users/jawa")
  end

  def install
    (prefix/"bin").mkpath
    (prefix/"homebrew.mxcl.homebrew-latest-refresh.plist").atomic_write refresh_plist
  end

  def post_install
    (prefix/"homebrew.mxcl.homebrew-latest-refresh.plist").atomic_write refresh_plist
  end

  def refresh_plist
    calendar_entries = (0..22).step(2).map do |hour|
      <<~XML
        <dict>
          <key>Hour</key>
          <integer>#{hour}</integer>
          <key>Minute</key>
          <integer>0</integer>
        </dict>
      XML
    end.join

    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>HOMEBREW_LATEST_TAP_DIR</key>
          <string>#{tap_root}</string>
          <key>HTTPS_PROXY</key>
          <string>http://127.0.0.1:6152</string>
          <key>HTTP_PROXY</key>
          <string>http://127.0.0.1:6152</string>
          <key>PATH</key>
          <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        </dict>
        <key>Label</key>
        <string>homebrew.mxcl.homebrew-latest-refresh</string>
        <key>LimitLoadToSessionType</key>
        <array>
          <string>Aqua</string>
          <string>Background</string>
          <string>LoginWindow</string>
          <string>StandardIO</string>
          <string>System</string>
        </array>
        <key>ProgramArguments</key>
        <array>
          <string>#{tap_root}/bin/refresh</string>
          <string>--upgrade</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{user_home}/Library/Logs/homebrew-latest-refresh.err.log</string>
        <key>StandardOutPath</key>
        <string>#{user_home}/Library/Logs/homebrew-latest-refresh.log</string>
        <key>StartCalendarInterval</key>
        <array>
      #{calendar_entries}
        </array>
        <key>WorkingDirectory</key>
        <string>#{tap_root}</string>
      </dict>
      </plist>
    XML
  end

  service do
    service_tap_root = Pathname.new("/opt/homebrew/Library/Taps/h4rk8s/homebrew-latest")

    run [service_tap_root/"bin/refresh"]
    working_dir service_tap_root
    run_type :interval
    interval 7200
    environment_variables PATH:                    "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin",
                          HOMEBREW_LATEST_TAP_DIR: service_tap_root.to_s,
                          HTTP_PROXY:              "http://127.0.0.1:6152",
                          HTTPS_PROXY:             "http://127.0.0.1:6152"
    log_path Pathname.new("/Users/jawa")/"Library/Logs/homebrew-latest-refresh.log"
    error_log_path Pathname.new("/Users/jawa")/"Library/Logs/homebrew-latest-refresh.err.log"
  end
end
