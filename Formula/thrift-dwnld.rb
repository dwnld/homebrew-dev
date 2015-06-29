require "formula"

class ThriftDwnld < Formula
  homepage "http://thrift.apache.org"
  version '1.0.0-dwnld-1'

  stable do
    url "https://github.com/dwnld/thrift.git", :branch => 'dwnld'
  end

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install PHP binding"
  option "with-libevent", "Install nonblocking server libraries"

  depends_on "boost"
  depends_on "openssl"
  depends_on "libevent" => :optional
  depends_on :python => :optional
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"

    exclusions = ["--without-ruby", "--disable-tests", "--without-php_extension"]

    exclusions << "--without-python" if build.without? "python"
    exclusions << "--without-haskell" if build.without? "haskell"
    exclusions << "--without-java" if build.without? "java"
    exclusions << "--without-perl" if build.without? "perl"
    exclusions << "--without-php" if build.without? "php"
    exclusions << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr:
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *exclusions
    ENV.j1
    system "make"
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    To install Ruby binding:
      gem install thrift

    To install PHP extension for e.g. PHP 5.5:
      brew install homebrew/php/php55-thrift
    EOS
  end
end
