{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.dev.cc.enable = lib.mkEnableOption "enable";

  config = lib.mkIf config.my.dev.cc.enable {
    users.users.jawz.packages = builtins.attrValues {
      inherit (pkgs)
        clang # C/C++ compiler frontend (part of LLVM)
        clang-tools # Extra LLVM tools (e.g. clang-tidy, clang-apply-replacements)
        gcc # GNU Compiler Collection (C, C++, etc.)
        gdb # GNU Debugger
        valgrind # Memory leak detector and performance profiler
        ;
    };
  };
}
