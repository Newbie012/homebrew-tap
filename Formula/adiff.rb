class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  version "0.1.0-alpha.182"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.182/adiff-darwin-arm64.tar.gz"
      sha256 "368c20862b3ef2f950af10da8e9b7aa1538b38a01f6e87a34cb76be63096c26a"
    end
    on_intel do
      url "https://github.com/Newbie012/agent-diff/releases/download/v0.1.0-alpha.182/adiff-darwin-x64.tar.gz"
      sha256 "6580705747b9bdafe6b12c8239c8d1cce2165e6870e0c44c929e6758e02c891f"
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
