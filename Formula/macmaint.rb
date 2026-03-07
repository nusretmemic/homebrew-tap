class Macmaint < Formula
  include Language::Python::Virtualenv

  desc "AI-powered CLI maintenance agent for macOS"
  homepage "https://github.com/nusretmemic/macmaint"
  url "https://github.com/nusretmemic/macmaint/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "433e234bb2edffb6ba11f66fdc8e7aeebc616e2cc6925b7e78798fa87d42f2be"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create a virtualenv
    venv = virtualenv_create(libexec, "python3.12")
    
    # Install dependencies first
    system libexec/"bin/pip", "install", "click>=8.1.0", "rich>=13.0.0", 
           "psutil>=5.9.0", "openai>=1.0.0", "pydantic>=2.0.0", 
           "pyyaml>=6.0.0", "python-dotenv>=1.0.0"
    
    # Then install the package
    system libexec/"bin/pip", "install", buildpath
    
    # Create symlink
    bin.install_symlink libexec/"bin/macmaint"
  end

  def caveats
    <<~EOS
      To use MacMaint, you need to:
      1. Run 'macmaint init' to set up your configuration
      2. Provide your OpenAI API key when prompted

      Configuration will be stored in: ~/.macmaint/
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/macmaint --help")
  end
end
