class Portlang < Formula
  desc "A CLI for building reliable, model-agnostic agents"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.4/portlang-aarch64-apple-darwin.tar.gz"
      sha256 "82c91a3e8358f296feea1cde804f948b4b18843a0e6c2c48e7bdbf7fe3840808"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
