# MetalChams for Critical Ops (iOS)

Enemy highlight wallhack for Critical Ops, based on Metal shader source patching.

Makes enemies visible through walls by forcing their highlight pass to render at the near plane — no color modification, so characters keep their original appearance.

## Credits

This project is based on the shader-hooking technique originally published by **[Scared1892](https://github.com/Scared1892)** in [MetalChams-iOS](https://github.com/Scared1892/MetalChams-iOS).

The original approach hooked `_MTLDevice newLibraryWithSource:options:error:` and patched shader source to force both a chams color and a depth override. This version:

- Keeps only the depth override (wallhack)

The dylib is produced at `.theos/obj/debug/arm64/metalchams.dylib`.

## Install

Inject the dylib into the Critical Ops binary (the usual Theos/substrate/repack flow), or sideload a repacked IPA.

Bundle ID: `com.criticalforce.criticalops`

## Disclaimer

For educational purposes only. Use at your own risk.
