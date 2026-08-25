class AgentFigma < Formula
  desc "Read-only Figma context for terminals and AI agents"
  homepage "https://github.com/Newbie012/agent-figma"
  version "0.1.0-alpha.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-figma/releases/download/v0.1.0-alpha.7/agent-figma-darwin-arm64.tar.gz"
      sha256 "b19d1b773f64a36d29452d59f15bde7c38c826569360214cb148d64bc630e7cc"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-figma/releases/download/v0.1.0-alpha.7/agent-figma-darwin-x64.tar.gz"
      sha256 "b98d60d7eecd0d1f3a65e3bb7cc9f2091a9b55a360df64c6d5d1087aec559fff"
    end
  end

  def install
    bin.install Dir["agent-figma-*"].first => "agent-figma"
    bin.install_symlink bin/"agent-figma" => "afg"
  end

  test do
    require "json"

    assert_equal version.to_s, shell_output("#{bin}/agent-figma --version").strip

    catalog = JSON.parse(shell_output("#{bin}/agent-figma describe --json"))
    assert catalog["read_only"]
    names = catalog["commands"].map { |command| command["path"].join(" ") }
    assert_includes names, "node get"

    # No token is configured under `brew test`, so this proves the refusal is the
    # authentication one and not a crash.
    refused = shell_output("#{bin}/agent-figma user get --json 2>&1", 1)
    assert_match "NotAuthenticated", refused
  end
end
