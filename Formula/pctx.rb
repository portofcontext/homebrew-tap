class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.7.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v0.7.7/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "42b48f9014604ed1480581f9bf1c7b8ba9475f03ec2bb76d91a767600b3d0643"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.7/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5c027224cf7ae38adbad59b63a5f951a9d3d60867c327a7aa151d4af6dd818bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.7/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a15ac5da9c3a002745e5b4732cf75e8be48c0c33e3a721af9b679b623d9ec5dd"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "generate-cli-docs", "pctx"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "generate-cli-docs", "pctx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "generate-cli-docs", "pctx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
