class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  version "0.1.0-alpha.118"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.118/adiff-darwin-arm64.tar.gz"
      sha256 "47ee1d9a9f76a265ef3d8f2c076265e32fb9c7ded93ceac717f3023c3a32da98"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.118/adiff-darwin-x64.tar.gz"
      sha256 "aa5740eaf792bc8852bcb900a3c41f48e3f44d4a2451ecf5a5b413eca96e5f3a"
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
