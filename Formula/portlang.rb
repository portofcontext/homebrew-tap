class Portlang < Formula
  desc "A CLI for building reliable, model-agnostic agents"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.17"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-aarch64-apple-darwin.tar.gz"
    sha256 "6a16dc83cbc1fc5d28413ce73ca573b114c71c88f7de160be81149f2d84d6e44"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "452a77627dc9102ea1975897c31d1e7ef60baf104c5a8b3b9458b79b054d6b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ff93cfd70aa0998f460c68b927a566aa03532ad9587046ffa8fb344677e1a4d"
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
    bin.install "portlang" if OS.mac? && Hardware::CPU.arm?
    bin.install "portlang" if OS.linux? && Hardware::CPU.arm?
    bin.install "portlang" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
