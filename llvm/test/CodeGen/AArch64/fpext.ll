; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 3
; RUN: llc -mtriple=aarch64 -global-isel=0 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-SD
; RUN: llc -mtriple=aarch64 -global-isel=1 -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=CHECK,CHECK-GI

define double @fpext_f32_f64(float %a) {
; CHECK-LABEL: fpext_f32_f64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d0, s0
; CHECK-NEXT:    ret
entry:
  %c = fpext float %a to double
  ret double %c
}

define double @fpext_f16_f64(half %a) {
; CHECK-LABEL: fpext_f16_f64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d0, h0
; CHECK-NEXT:    ret
entry:
  %c = fpext half %a to double
  ret double %c
}

define float @fpext_f16_f32(half %a) {
; CHECK-LABEL: fpext_f16_f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt s0, h0
; CHECK-NEXT:    ret
entry:
  %c = fpext half %a to float
  ret float %c
}

define fp128 @fpext_f16_f128(half %a) {
; CHECK-LABEL: fpext_f16_f128:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    b __extendhftf2
entry:
  %c = fpext half %a to fp128
  ret fp128 %c
}

define fp128 @fpext_f32_f128(float %a) {
; CHECK-LABEL: fpext_f32_f128:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    b __extendsftf2
entry:
  %c = fpext float %a to fp128
  ret fp128 %c
}

define fp128 @fpext_f64_f128(double %a) {
; CHECK-LABEL: fpext_f64_f128:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    b __extenddftf2
entry:
  %c = fpext double %a to fp128
  ret fp128 %c
}

define <2 x double> @fpext_v2f32_v2f64(<2 x float> %a) {
; CHECK-LABEL: fpext_v2f32_v2f64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtl v0.2d, v0.2s
; CHECK-NEXT:    ret
entry:
  %c = fpext <2 x float> %a to <2 x double>
  ret <2 x double> %c
}

define <3 x double> @fpext_v3f32_v3f64(<3 x float> %a) {
; CHECK-SD-LABEL: fpext_v3f32_v3f64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl v3.2d, v0.2s
; CHECK-SD-NEXT:    fcvtl2 v2.2d, v0.4s
; CHECK-SD-NEXT:    ext v1.16b, v3.16b, v3.16b, #8
; CHECK-SD-NEXT:    fmov d0, d3
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v3f32_v3f64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov s1, v0.s[2]
; CHECK-GI-NEXT:    fcvtl v0.2d, v0.2s
; CHECK-GI-NEXT:    fcvt d2, s1
; CHECK-GI-NEXT:    mov d1, v0.d[1]
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <3 x float> %a to <3 x double>
  ret <3 x double> %c
}

define <4 x fp128> @fpext_v4f16_v4f128(<4 x half> %a) {
; CHECK-SD-LABEL: fpext_v4f16_v4f128:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    sub sp, sp, #64
; CHECK-SD-NEXT:    str x30, [sp, #48] // 8-byte Folded Spill
; CHECK-SD-NEXT:    .cfi_def_cfa_offset 64
; CHECK-SD-NEXT:    .cfi_offset w30, -16
; CHECK-SD-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-SD-NEXT:    bl __extendhftf2
; CHECK-SD-NEXT:    ldr q1, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-SD-NEXT:    mov h1, v1.h[1]
; CHECK-SD-NEXT:    fmov s0, s1
; CHECK-SD-NEXT:    bl __extendhftf2
; CHECK-SD-NEXT:    ldr q1, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-SD-NEXT:    mov h1, v1.h[2]
; CHECK-SD-NEXT:    fmov s0, s1
; CHECK-SD-NEXT:    bl __extendhftf2
; CHECK-SD-NEXT:    ldr q1, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-SD-NEXT:    mov h1, v1.h[3]
; CHECK-SD-NEXT:    fmov s0, s1
; CHECK-SD-NEXT:    bl __extendhftf2
; CHECK-SD-NEXT:    mov v3.16b, v0.16b
; CHECK-SD-NEXT:    ldp q1, q0, [sp] // 32-byte Folded Reload
; CHECK-SD-NEXT:    ldr q2, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    ldr x30, [sp, #48] // 8-byte Folded Reload
; CHECK-SD-NEXT:    add sp, sp, #64
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v4f16_v4f128:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    sub sp, sp, #80
; CHECK-GI-NEXT:    str d10, [sp, #48] // 8-byte Folded Spill
; CHECK-GI-NEXT:    stp d9, d8, [sp, #56] // 16-byte Folded Spill
; CHECK-GI-NEXT:    str x30, [sp, #72] // 8-byte Folded Spill
; CHECK-GI-NEXT:    .cfi_def_cfa_offset 80
; CHECK-GI-NEXT:    .cfi_offset w30, -8
; CHECK-GI-NEXT:    .cfi_offset b8, -16
; CHECK-GI-NEXT:    .cfi_offset b9, -24
; CHECK-GI-NEXT:    .cfi_offset b10, -32
; CHECK-GI-NEXT:    mov h8, v0.h[1]
; CHECK-GI-NEXT:    mov h9, v0.h[2]
; CHECK-GI-NEXT:    mov h10, v0.h[3]
; CHECK-GI-NEXT:    bl __extendhftf2
; CHECK-GI-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s8
; CHECK-GI-NEXT:    bl __extendhftf2
; CHECK-GI-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s9
; CHECK-GI-NEXT:    bl __extendhftf2
; CHECK-GI-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s10
; CHECK-GI-NEXT:    bl __extendhftf2
; CHECK-GI-NEXT:    mov v3.16b, v0.16b
; CHECK-GI-NEXT:    ldp q1, q0, [sp, #16] // 32-byte Folded Reload
; CHECK-GI-NEXT:    ldp d9, d8, [sp, #56] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr q2, [sp] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr x30, [sp, #72] // 8-byte Folded Reload
; CHECK-GI-NEXT:    ldr d10, [sp, #48] // 8-byte Folded Reload
; CHECK-GI-NEXT:    add sp, sp, #80
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <4 x half> %a to <4 x fp128>
  ret <4 x fp128> %c
}

define <4 x fp128> @fpext_v4f32_v4f128(<4 x float> %a) {
; CHECK-SD-LABEL: fpext_v4f32_v4f128:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    sub sp, sp, #80
; CHECK-SD-NEXT:    str x30, [sp, #64] // 8-byte Folded Spill
; CHECK-SD-NEXT:    .cfi_def_cfa_offset 80
; CHECK-SD-NEXT:    .cfi_offset w30, -16
; CHECK-SD-NEXT:    str q0, [sp, #48] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-SD-NEXT:    bl __extendsftf2
; CHECK-SD-NEXT:    ldr q1, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-SD-NEXT:    mov s1, v1.s[1]
; CHECK-SD-NEXT:    fmov s0, s1
; CHECK-SD-NEXT:    bl __extendsftf2
; CHECK-SD-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ldr q0, [sp, #48] // 16-byte Folded Reload
; CHECK-SD-NEXT:    bl __extendsftf2
; CHECK-SD-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ldr q0, [sp, #48] // 16-byte Folded Reload
; CHECK-SD-NEXT:    mov s0, v0.s[1]
; CHECK-SD-NEXT:    bl __extendsftf2
; CHECK-SD-NEXT:    mov v1.16b, v0.16b
; CHECK-SD-NEXT:    ldp q0, q3, [sp] // 32-byte Folded Reload
; CHECK-SD-NEXT:    ldr q2, [sp, #32] // 16-byte Folded Reload
; CHECK-SD-NEXT:    ldr x30, [sp, #64] // 8-byte Folded Reload
; CHECK-SD-NEXT:    add sp, sp, #80
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v4f32_v4f128:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    sub sp, sp, #80
; CHECK-GI-NEXT:    str d10, [sp, #48] // 8-byte Folded Spill
; CHECK-GI-NEXT:    stp d9, d8, [sp, #56] // 16-byte Folded Spill
; CHECK-GI-NEXT:    str x30, [sp, #72] // 8-byte Folded Spill
; CHECK-GI-NEXT:    .cfi_def_cfa_offset 80
; CHECK-GI-NEXT:    .cfi_offset w30, -8
; CHECK-GI-NEXT:    .cfi_offset b8, -16
; CHECK-GI-NEXT:    .cfi_offset b9, -24
; CHECK-GI-NEXT:    .cfi_offset b10, -32
; CHECK-GI-NEXT:    mov s8, v0.s[1]
; CHECK-GI-NEXT:    mov s9, v0.s[2]
; CHECK-GI-NEXT:    mov s10, v0.s[3]
; CHECK-GI-NEXT:    bl __extendsftf2
; CHECK-GI-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s8
; CHECK-GI-NEXT:    bl __extendsftf2
; CHECK-GI-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s9
; CHECK-GI-NEXT:    bl __extendsftf2
; CHECK-GI-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov s0, s10
; CHECK-GI-NEXT:    bl __extendsftf2
; CHECK-GI-NEXT:    mov v3.16b, v0.16b
; CHECK-GI-NEXT:    ldp q1, q0, [sp, #16] // 32-byte Folded Reload
; CHECK-GI-NEXT:    ldp d9, d8, [sp, #56] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr q2, [sp] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr x30, [sp, #72] // 8-byte Folded Reload
; CHECK-GI-NEXT:    ldr d10, [sp, #48] // 8-byte Folded Reload
; CHECK-GI-NEXT:    add sp, sp, #80
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <4 x float> %a to <4 x fp128>
  ret <4 x fp128> %c
}

define <4 x fp128> @fpext_v4f64_v4f128(<4 x double> %a) {
; CHECK-SD-LABEL: fpext_v4f64_v4f128:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    sub sp, sp, #80
; CHECK-SD-NEXT:    str x30, [sp, #64] // 8-byte Folded Spill
; CHECK-SD-NEXT:    .cfi_def_cfa_offset 80
; CHECK-SD-NEXT:    .cfi_offset w30, -16
; CHECK-SD-NEXT:    str q1, [sp, #48] // 16-byte Folded Spill
; CHECK-SD-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-SD-NEXT:    bl __extenddftf2
; CHECK-SD-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ldr q0, [sp, #16] // 16-byte Folded Reload
; CHECK-SD-NEXT:    mov d0, v0.d[1]
; CHECK-SD-NEXT:    bl __extenddftf2
; CHECK-SD-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ldr q0, [sp, #48] // 16-byte Folded Reload
; CHECK-SD-NEXT:    bl __extenddftf2
; CHECK-SD-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-SD-NEXT:    ldr q0, [sp, #48] // 16-byte Folded Reload
; CHECK-SD-NEXT:    mov d0, v0.d[1]
; CHECK-SD-NEXT:    bl __extenddftf2
; CHECK-SD-NEXT:    mov v3.16b, v0.16b
; CHECK-SD-NEXT:    ldp q1, q0, [sp, #16] // 32-byte Folded Reload
; CHECK-SD-NEXT:    ldr q2, [sp] // 16-byte Folded Reload
; CHECK-SD-NEXT:    ldr x30, [sp, #64] // 8-byte Folded Reload
; CHECK-SD-NEXT:    add sp, sp, #80
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v4f64_v4f128:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    sub sp, sp, #80
; CHECK-GI-NEXT:    stp d9, d8, [sp, #48] // 16-byte Folded Spill
; CHECK-GI-NEXT:    str x30, [sp, #64] // 8-byte Folded Spill
; CHECK-GI-NEXT:    .cfi_def_cfa_offset 80
; CHECK-GI-NEXT:    .cfi_offset w30, -16
; CHECK-GI-NEXT:    .cfi_offset b8, -24
; CHECK-GI-NEXT:    .cfi_offset b9, -32
; CHECK-GI-NEXT:    str q1, [sp] // 16-byte Folded Spill
; CHECK-GI-NEXT:    mov d8, v0.d[1]
; CHECK-GI-NEXT:    mov d9, v1.d[1]
; CHECK-GI-NEXT:    bl __extenddftf2
; CHECK-GI-NEXT:    str q0, [sp, #32] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov d0, d8
; CHECK-GI-NEXT:    bl __extenddftf2
; CHECK-GI-NEXT:    str q0, [sp, #16] // 16-byte Folded Spill
; CHECK-GI-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-GI-NEXT:    bl __extenddftf2
; CHECK-GI-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-GI-NEXT:    fmov d0, d9
; CHECK-GI-NEXT:    bl __extenddftf2
; CHECK-GI-NEXT:    mov v3.16b, v0.16b
; CHECK-GI-NEXT:    ldp q1, q0, [sp, #16] // 32-byte Folded Reload
; CHECK-GI-NEXT:    ldp d9, d8, [sp, #48] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr q2, [sp] // 16-byte Folded Reload
; CHECK-GI-NEXT:    ldr x30, [sp, #64] // 8-byte Folded Reload
; CHECK-GI-NEXT:    add sp, sp, #80
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <4 x double> %a to <4 x fp128>
  ret <4 x fp128> %c
}

define <4 x double> @fpext_v4f32_v4f64(<4 x float> %a) {
; CHECK-SD-LABEL: fpext_v4f32_v4f64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl2 v1.2d, v0.4s
; CHECK-SD-NEXT:    fcvtl v0.2d, v0.2s
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v4f32_v4f64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fcvtl v2.2d, v0.2s
; CHECK-GI-NEXT:    fcvtl2 v1.2d, v0.4s
; CHECK-GI-NEXT:    mov v0.16b, v2.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <4 x float> %a to <4 x double>
  ret <4 x double> %c
}

define <2 x double> @fpext_v2f16_v2f64(<2 x half> %a) {
; CHECK-SD-LABEL: fpext_v2f16_v2f64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-SD-NEXT:    fcvtl v0.2d, v0.2s
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v2f16_v2f64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov h1, v0.h[1]
; CHECK-GI-NEXT:    fcvt d0, h0
; CHECK-GI-NEXT:    fcvt d1, h1
; CHECK-GI-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <2 x half> %a to <2 x double>
  ret <2 x double> %c
}

define <3 x double> @fpext_v3f16_v3f64(<3 x half> %a) {
; CHECK-SD-LABEL: fpext_v3f16_v3f64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl v1.4s, v0.4h
; CHECK-SD-NEXT:    fcvtl v0.2d, v1.2s
; CHECK-SD-NEXT:    fcvtl2 v2.2d, v1.4s
; CHECK-SD-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v3f16_v3f64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov h1, v0.h[1]
; CHECK-GI-NEXT:    mov h2, v0.h[2]
; CHECK-GI-NEXT:    fcvt d0, h0
; CHECK-GI-NEXT:    fcvt d1, h1
; CHECK-GI-NEXT:    fcvt d2, h2
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <3 x half> %a to <3 x double>
  ret <3 x double> %c
}

define <4 x double> @fpext_v4f16_v4f64(<4 x half> %a) {
; CHECK-SD-LABEL: fpext_v4f16_v4f64:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-SD-NEXT:    fcvtl2 v1.2d, v0.4s
; CHECK-SD-NEXT:    fcvtl v0.2d, v0.2s
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v4f16_v4f64:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    mov h1, v0.h[1]
; CHECK-GI-NEXT:    mov h2, v0.h[2]
; CHECK-GI-NEXT:    mov h3, v0.h[3]
; CHECK-GI-NEXT:    fcvt d0, h0
; CHECK-GI-NEXT:    fcvt d4, h1
; CHECK-GI-NEXT:    fcvt d1, h2
; CHECK-GI-NEXT:    fcvt d2, h3
; CHECK-GI-NEXT:    mov v0.d[1], v4.d[0]
; CHECK-GI-NEXT:    mov v1.d[1], v2.d[0]
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <4 x half> %a to <4 x double>
  ret <4 x double> %c
}

define <2 x float> @fpext_v2f16_v2f32(<2 x half> %a) {
; CHECK-LABEL: fpext_v2f16_v2f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-NEXT:    ret
entry:
  %c = fpext <2 x half> %a to <2 x float>
  ret <2 x float> %c
}

define <3 x float> @fpext_v3f16_v3f32(<3 x half> %a) {
; CHECK-LABEL: fpext_v3f16_v3f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-NEXT:    ret
entry:
  %c = fpext <3 x half> %a to <3 x float>
  ret <3 x float> %c
}

define <4 x float> @fpext_v4f16_v4f32(<4 x half> %a) {
; CHECK-LABEL: fpext_v4f16_v4f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-NEXT:    ret
entry:
  %c = fpext <4 x half> %a to <4 x float>
  ret <4 x float> %c
}

define <8 x float> @fpext_v8f16_v8f32(<8 x half> %a) {
; CHECK-SD-LABEL: fpext_v8f16_v8f32:
; CHECK-SD:       // %bb.0: // %entry
; CHECK-SD-NEXT:    fcvtl2 v1.4s, v0.8h
; CHECK-SD-NEXT:    fcvtl v0.4s, v0.4h
; CHECK-SD-NEXT:    ret
;
; CHECK-GI-LABEL: fpext_v8f16_v8f32:
; CHECK-GI:       // %bb.0: // %entry
; CHECK-GI-NEXT:    fcvtl v2.4s, v0.4h
; CHECK-GI-NEXT:    fcvtl2 v1.4s, v0.8h
; CHECK-GI-NEXT:    mov v0.16b, v2.16b
; CHECK-GI-NEXT:    ret
entry:
  %c = fpext <8 x half> %a to <8 x float>
  ret <8 x float> %c
}
