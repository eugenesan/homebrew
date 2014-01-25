require "formula"

class Horndis < Formula
  homepage "http://joshuawise.com/horndis"
  url "https://github.com/jwise/HoRNDIS/archive/rel5.tar.gz"
  sha1 "5f01c62ae61554252c0fe727e414edcb8e060106"

  depends_on :xcode

  def install
    inreplace "HoRNDIS.xcodeproj/project.pbxproj", "GCC_VERSION = com.apple.compilers.llvmgcc42;\n", ""
    inreplace "HoRNDIS.xcodeproj/project.pbxproj", "MACOSX_DEPLOYMENT_TARGET = 10.6;\n", ""
    inreplace "HoRNDIS.xcodeproj/project.pbxproj", "SDKROOT = macosx10.6;", "ONLY_ACTIVE_ARCH = YES;"

    system "xcodebuild -sdk macosx#{MacOS.version}"
    kext_prefix.install "build/Release/HoRNDIS.kext"
  end

  def caveats
    message = <<-EOS.undent
      In order for HoRNDIS to work, kernel extension must be installed by the root user:
        $ sudo /bin/cp -rfX #{kext_prefix}/HoRNDIS.kext /Library/Extensions

      If upgrading from a previous version of HoRNDIS, the old kernel extension will need
      to be unloaded before performing the steps listed above.
      First, disconnect all RNDIS devices and then, unload the kernel extension:
        $ sudo kextunload -b com.joshuawise.kexts.HoRNDIS
    EOS
    return message
  end
end
