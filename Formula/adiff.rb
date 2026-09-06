class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  version "0.1.0-alpha.179"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.179/adiff-darwin-arm64.tar.gz"
      sha256 "24bd5b936c4bd50defc774cfae6c8fc2ed5a0b3409d8216d57e5901d3f7520df"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.179/adiff-darwin-x64.tar.gz"
      sha256 "778eccf3c6a37d54478a19b6526fab719135e4a5d0450c3d6d55439843bb4d79"
    end
  end

  def install
    bin.install Dir["adiff-*"].first => "adiff"
  end

  test do
    require "json"

    catalog = JSON.parse(shell_output("#{bin}/adiff describe"))
    assert catalog["ok"]
    names = catalog["commands"].map { |command| command["name"] }
    assert_includes names, "review open"

    system "git", "init", "--initial-branch=main", testpath/"repo"
    (testpath/"repo/README.md").write "hello\n"
    system "git", "-C", testpath/"repo", "add", "README.md"
    system "git", "-C", testpath/"repo", "-c", "user.name=brew",
           "-c", "user.email=brew@example.com", "commit", "-m", "first"

    branches = JSON.parse(shell_output("#{bin}/adiff branch list --repo #{testpath}/repo"))
    assert branches["ok"]
    assert_kind_of Array, branches["branches"]
  end
end
