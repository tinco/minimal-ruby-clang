require 'mkmf'

module MakeMakefile
  alias_method :original_try_header, :try_header

  def try_header(header, *opts, &b)
    result = original_try_header(header, *opts, &b)
    return result if result || opts.empty?
    opts.each do |opt|
      _,path = opt.split("-I")
      if path && File.exists?(path + "/" + header)
        return true
      end
    end
  end
end

# Give it a name
extension_name = 'mytest'

# The destination
dir_config(extension_name)

$CXXFLAGS += " -std=c++11 "

find_header("clang/AST/ASTContext.h", "/Users/tinco/Source/amirrajan/BridgeSupport/OBJROOT/clang-70/darwin-x86_64/ROOT/usr/local/include")

llvm_libs_path = "/Users/tinco/Source/amirrajan/BridgeSupport/OBJROOT/clang-70/darwin-x86_64/ROOT/usr/local/lib"

$LDFLAGS += " -L#{llvm_libs_path} "

[
    'clangCodeGen',
    'clangAnalysis',
    'clangARCMigrate',
    'clangRewriteFrontend',
    'clangSema',
    'clangSerialization',
    'clangFrontend',
    'clangEdit',
    'clangDriver',
    'clangAST',
    'clangParse',
    'clangLex',
    'clangBasic',
    'LLVMCore',
    'LLVMSupport',
    'LLVMBitWriter',
    'LLVMBitReader',
    'LLVMCodeGen',
    'LLVMAnalysis',
    'LLVMTarget',
    'LLVMMC',
    'LLVMMCParser',
    'LLVMOption',
].reverse.each {|l| $libs = append_library($libs, l)}

# Do the work
create_makefile(extension_name)

