class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v0.2.0/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "090f8b32071dae1c2f6f4505c0aa6e213d214e58ba5e1305ea7b99ddc5012f02"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.2.0/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0dc7193d6f0651eed3e86c883e0f6b84fd4ae7fedc68a3c8dc1ea4543777e295"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.2.0/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c5c5e7da6e34679b1d8f6f08da34344b7ec864478929ca32be3e302d9ff73ba1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
