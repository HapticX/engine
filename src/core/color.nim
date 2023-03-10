#[
  Provides working with color
]#
import
  strformat,
  strutils,
  math,
  ./hmath


type
  Color* = object
    r*, g*, b*, a*: float
  BlendMode* {.pure, size: sizeof(int8).} = enum
    Normal,
    Screen,
    Multiply,
    Overlay,
    Addition,
    Substract,
    Divide,
    Diffirence,
    Darken,
    Lighten,
    SoftLight


const
  TransparentClr* = Color(r: 0f, g: 0f, b: 0f, a: 0f)
  WhiteClr* = Color(r: 1f, g: 1f, b: 1f, a: 1f)
  BlackClr* = Color(r: 0f, g: 0f, b: 0f, a: 1f)
  RedClr* = Color(r: 1f, g: 0f, b: 0f, a: 1f)
  GreenClr* = Color(r: 0f, g: 1f, b: 0f, a: 1f)
  BlueClr* = Color(r: 0f, g: 0f, b: 1f, a: 1f)
  CyanClr* = Color(r: 0f, g: 1f, b: 1f, a: 1f)
  GrayClr* = Color(r: 0.75f, g: 0.75f, b: 0.75f, a: 1f)
  PurpleClr* = Color(r: 0.63f, g: 0.13f, b: 0.94f, a: 1f)
  RebeccaPurpleClr* = Color(r: 0.4f, g: 0.2f, b: 0.6f, a: 1f)
  MaroonClr* = Color(r: 0.69f, g: 0.19f, b: 0.38f, a: 1f)
  OrangeClr* = Color(r: 1f, g: 0.65, b: 0f, a: 1f)


func newColor*: Color =
  ## Creates a new color object with default values.
  ## Color(1f, 1f, 1f, 1f)
  Color(r: 1f, g: 1f, b: 1f, a: 1f)
func newColor*(r, g, b: float): Color =
  ## Creates a new color object with default alpha value.
  ## Color(`r`, `g`, `b`, 1f)
  Color(r: r, g: g, b: b, a: 1)
func newColor*(r, g, b, a: float): Color =
  ## Creates a new color.
  ## Color(`r`, `g`, `b`, `a`)
  Color(r: r, g: g, b: b, a: a)
func newColor*(brightness: float): Color =
  ## Creates a new color.
  ## Color(`brightness`, `brightness`, `brightness`, 1f)
  Color(r: brightness, g: brightness, b: brightness, a: 1f)
func newColor*(a: Color): Color =
  ## Creates a new color from other color.
  ## Color(`brightness`, `brightness`, `brightness`, 1f)
  Color(r: a.r, g: a.g, b: a.b, a: a.a)


func newColor*(r, g, b: uint): Color =
  ## Creates a new color from unsigned integer with default alpha value (1f).
  Color(
    r: r.float / 255f,
    g: g.float / 255f,
    b: b.float / 255f,
    a: 1f
  )
func newColor*(r, g, b, a: uint): Color =
  ## Creates a new color from unsigned integers.
  Color(
    r: r.float / 255f,
    g: g.float / 255f,
    b: b.float / 255f,
    a: a.float / 255f
  )


when not defined(js):
  func newColor*(hexInteger: int64): Color =
    ## Creates a new color from one HEX 0xRRGGBBAA unsigned integer.
    Color(
      r: ((hexInteger and 0xFF000000) shr 24).float / 255f,
      g: ((hexInteger and 0x00FF0000) shr 16).float / 255f,
      b: ((hexInteger and 0x0000FF00) shr 8).float / 255f,
      a: (hexInteger and 0x000000FF).float / 255f
    )

func newColor*(hexInteger: int): Color =
  ## Creates a new color from one HEX 0xRRGGBB unsigned integer.
  Color(
    r: ((hexInteger and 0xFF0000) shr 16).float / 255f,
    g: ((hexInteger and 0x00FF00) shr 8).float / 255f,
    b: (hexInteger and 0x0000FF).float / 255f,
    a: 1f
  )


func newColor*(hexString: string): Color =
  ## Creates a new color from HEX string that starts with `0x`, `0X` or `#`.
  newColor(parseHexInt(hexString))


# --== Operators ==-- #
func `$`*(clr: Color): string =
  ## Casts color into string
  fmt"clr({clr.r}, {clr.g}, {clr.b}, {clr.a})"

template provideOperator(funcname, op: untyped): untyped =
  func `funcname`*(a, b: Color): Color =
    Color(
      r: `op`(a.r, b.r),
      g: `op`(a.g, b.g),
      b: `op`(a.b, b.b),
      a: `op`(a.a, b.a)
    )
  func `funcname`*(a: float32, b: Color): Color =
    Color(
      r: `op`(a, b.r),
      g: `op`(a, b.g),
      b: `op`(a, b.b),
      a: `op`(a, b.a)
    )
  func `funcname`*(a: Color, b: float32): Color =
    Color(
      r: `op`(a.r, b),
      g: `op`(a.g, b),
      b: `op`(a.b, b),
      a: `op`(a.a, b)
    )

template provideOperatorVar(operatorFunc, op: untyped): untyped =
  func `operatorFunc`*(a: var Color, b: Color) =
    `op`(a.r, b.r)
    `op`(a.g, b.g)
    `op`(a.b, b.b)
    `op`(a.a, b.a)
  func `operatorFunc`*(a: var Color, b: float) =
    `op`(a.r, b)
    `op`(a.g, b)
    `op`(a.b, b)
    `op`(a.a, b)

template provideBinOperator(funcname, op: untyped): untyped =
  func `funcname`*(a, b: Color): bool =
    `op`(a.r, b.r) and
    `op`(a.g, b.g) and
    `op`(a.b, b.b) and
    `op`(a.a, b.a)
  func `funcname`*(a: float32, b: Color): bool =
    `op`(a, b.r) and
    `op`(a, b.g) and
    `op`(a, b.b) and
    `op`(a, b.a)
  func `funcname`*(a: Color, b: float32): bool =
    `op`(a.r, b) and
    `op`(a.g, b) and
    `op`(a.b, b) and
    `op`(a.a, b)

provideOperator(`*`, `*`)
provideOperator(`-`, `-`)
provideOperator(`+`, `+`)
provideOperator(`/`, `/`)

provideOperatorVar(`*=`, `*=`)
provideOperatorVar(`-=`, `-=`)
provideOperatorVar(`+=`, `+=`)
provideOperatorVar(`/=`, `/=`)

provideBinOperator(`>`, `>`)
provideBinOperator(`<`, `<`)
provideBinOperator(`==`, `==`)
provideBinOperator(`!=`, `!=`)


# --== Methods ==-- #
template provideFunc4Colors(funcname: untyped): untyped =
  func `funcname`*(a, b: Color): Color = 
    Color(
      r: `funcname`(a.r, b.r),
      g: `funcname`(a.g, b.g),
      b: `funcname`(a.b, b.b),
      a: `funcname`(a.a, b.a)
    )
template provideFunc4Color(funcname: untyped): untyped =
  func `funcname`*(a: Color): Color = 
    Color(
      r: `funcname`(a.r),
      g: `funcname`(a.g),
      b: `funcname`(a.b),
      a: `funcname`(a.a)
    )

provideFunc4Colors(min)
provideFunc4Colors(max)
provideFunc4Color(sqrt)
provideFunc4Color(abs)


func blend*(a, b: Color, blendMode: BlendMode = BlendMode.Normal): Color =
  ## Blends two colors
  case blendMode
    of BlendMode.Normal:
      b
    of BlendMode.Multiply:
      a*b
    of BlendMode.Screen:
      1 - (1 - a)*(1 - b)
    of BlendMode.Overlay:
      if a < 0.5:
        2*a*b
      else:
        1 - 2*(1 - a)*(1 - b)
    of BlendMode.Addition:
      a+b
    of BlendMode.Substract:
      a-b
    of BlendMode.Divide:
      a/b
    of BlendMode.Diffirence:
      if a > b:
        a - b
      else:
        b - a
    of BlendMode.Darken:
      min(a, b)
    of BlendMode.Lighten:
      max(a, b)
    of BlendMode.SoftLight:
      if b < 0.5:
        2*a*b + a*a*(1 - 2*b)
      else:
        2*a*(1 - b) + sqrt(a)*(2*b - 1)


# --== Other color systems ==-- #
func `hue`*(a: Color): float32 =
  ## Calculates hue value and returns it
  let
    maxValue = max(a.r, max(a.g, a.b))
    minValue = min(a.r, min(a.g, a.b))
    delta = maxValue - minValue

  if delta != 0f:
    if a.r == maxValue:
      result = (a.g - a.b) / delta
    elif a.g == maxValue:
      result = 2f + (a.b - a.r) / delta
    else:
      result = 4f + (a.r - a.g) / delta
    result *= 60f
    if result < 0f:
      result += 360f
  result = result / 360f

func `saturation`*(a: Color): float32 =
  ## Calculates saturation and returns it
  let
    maxValue = max(a.r, max(a.g, a.b))
    minValue = min(a.r, min(a.g, a.b))
    delta = maxValue - minValue
  
  if maxValue == 0:
    0f
  else:
    (delta / maxValue)

func `brightness`*(a: Color): float32 {.inline.} =
  ## Calculates color brightness
  max(a.r, max(a.g, a.b))

when not defined(js):
  func `hex`*(a: Color): int64 =
    ## Returns HEX integer
    (
      ((a.r * 255f).int64 shl 24) or
      ((a.g * 255f).int64 shl 16) or
      ((a.b * 255f).int64 shl 8) or
      (a.a * 255f).int64
    )
else:
  func `hex`*(a: Color): int =
    ## Returns HEX integer
    (
      ((a.r * 255f).int shl 16) or
      ((a.g * 255f).int shl 8) or
      ((a.b * 255f).int)
    )

func interpolate*(a, b: Color, t: float): Color {.inline.} =
  ## Returns linear interpolated color between `a` and `b` by `t`.
  a + (b-a)*t

func cubic_interpolate*(a, b, ca, cb: Color, t: float): Color =
  ## Returns cubic interpolated color between `a` and `b`.
  Color(
    r: cubic_interpolate(a.r, b.r, ca.r, cb.r, t),
    g: cubic_interpolate(a.g, b.g, ca.g, cb.g, t),
    b: cubic_interpolate(a.b, b.b, ca.b, cb.b, t),
    a: cubic_interpolate(a.a, b.a, ca.a, cb.a, t)
  )
