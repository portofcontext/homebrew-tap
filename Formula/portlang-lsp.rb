class PortlangLsp < Formula
  desc "The portlang-lsp application"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.18"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-lsp-aarch64-apple-darwin.tar.gz"
    sha256 "229c1cd7b01fb873b5b291b79953de783fe19378a9657bb9e2e4d6d819d98a8b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-lsp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "775a968aba80e745e3053ac00aacdb4b45a9b1977892f4b85767c3419ded9f38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-lsp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "89c555d425bffd51d872aff4eb6c6664612e4ba7fe80e15cd62ddd520e535cbc"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "portlang-lsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "portlang-lsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "portlang-lsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
