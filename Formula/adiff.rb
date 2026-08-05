class Adiff < Formula
  desc "Review agent work in a git worktree and hand the comments back to the agent"
  homepage "https://github.com/Newbie012/agent-diff"
  url "https://registry.npmjs.org/@eliya-oss/agent-diff/-/agent-diff-0.1.0-alpha.22.tgz"
  sha256 "d50c30224f7c8a37b686cf7dc0bab910220bb505449936471d532996a9c9cb80"
  license "MIT"

  depends_on "node@26"

  def install
    system "npm", "install", *std_npm_args
    launcher = libexec/"lib/node_modules/@eliya-oss/agent-diff/bin/adiff.js"
    # The terminal renders through node:ffi, so put the node this formula
    # depends on ahead of whatever node the user happens to be running.
    (bin/"adiff").write <<~BASH
      #!/bin/bash
      export PATH="#{Formula["node@26"].opt_bin}:$PATH"
      exec "#{launcher}" "$@"
    BASH
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
