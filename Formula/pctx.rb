class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.4.3"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.4.3/pctx-aarch64-apple-darwin.tar.gz"
      sha256 "beb6a21dfbdcd2320c2ea088924deea33430e69ab26c1041ac021d5fb8ba07a5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.4.3/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7ca6f260045e9f9b208cd5b1e8dc0eece1aaa9dd47674ce6e630d4c57da2cf5f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.4.3/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cd3f3c7823b33c55b03b04c6350178867de3c2e379a9ba8e2fb2734ae44e6796"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "generate-cli-docs", "pctx" if OS.mac? && Hardware::CPU.arm?
    bin.install "generate-cli-docs", "pctx" if OS.linux? && Hardware::CPU.arm?
    bin.install "generate-cli-docs", "pctx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
