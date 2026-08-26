class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  version "0.1.0-alpha.167"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.167/adiff-darwin-arm64.tar.gz"
      sha256 "2564c05c1ad62a7c8bb68f28cc6f8674293a58fc8956e384c9adece9040c23c3"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.167/adiff-darwin-x64.tar.gz"
      sha256 "38b4c0e678ca4110f395b3f5d73c13df66b6bbefa81be86324fae4fb2dd95b25"
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
