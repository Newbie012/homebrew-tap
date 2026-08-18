class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  version "0.1.0-alpha.76"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.76/adiff-darwin-arm64.tar.gz"
      sha256 "d9be9c9cfd1f817121e22c0c35f467c260c0551bbb76dba81759fc6b50ecdb6c"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.76/adiff-darwin-x64.tar.gz"
      sha256 "69b436dacc7d59c05981e1aeb2f0d37d7c4066498fbe3172bd68308ad252fc63"
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
