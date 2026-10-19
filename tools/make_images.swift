// SNS で共有したときの画像（og.png）と、ホーム画面・タブのアイコンを作る。
//
// 使い方（このリポジトリのルートで。Mac のみ）:
//   swift tools/make_images.swift
//
// images/monokun.png（モノくん）をもとに、次の 3 つを書き出す。
//   og.png                1200×630  SNS で共有したときの画像
//   apple-touch-icon.png  180×180   iPhone のホーム画面に追加したときのアイコン
//   favicon.png           64×64     ブラウザのタブのアイコン
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let monokun = NSImage(contentsOf: root.appendingPathComponent("images/monokun.png"))!

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: CGFloat((hex >> 16) & 0xff) / 255,
             green: CGFloat((hex >> 8) & 0xff) / 255,
             blue: CGFloat(hex & 0xff) / 255,
             alpha: alpha)
}

let cream = color(0xf8f4e9)
let orange = color(0xff8c42)
let orangeInk = color(0xb04a0a)
let ink = color(0x43382f)
let peach = color(0xffe3cc)

func font(_ name: String, _ size: CGFloat) -> NSFont {
    NSFont(name: name, size: size) ?? NSFont.boldSystemFont(ofSize: size)
}

// 左下が原点の座標で描く（AppKit の座標）。
func render(_ width: Int, _ height: Int, _ path: String, _ draw: () -> Void) {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
                               bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                               colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    rep.size = NSSize(width: width, height: height)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high
    draw()
    NSGraphicsContext.restoreGraphicsState()
    try! rep.representation(using: .png, properties: [:])!.write(to: root.appendingPathComponent(path))
    print("書き出し: \(path)")
}

func text(_ string: String, _ font: NSFont, _ color: NSColor, at point: NSPoint, kern: CGFloat = 0) {
    NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color, .kern: kern])
        .draw(at: point)
}

func pill(_ string: String, x: CGFloat, y: CGFloat, fill: NSColor, textColor: NSColor) -> CGFloat {
    let f = font("HiraginoSans-W6", 26)
    let label = NSAttributedString(string: string, attributes: [.font: f, .foregroundColor: textColor])
    let size = label.size()
    let rect = NSRect(x: x, y: y, width: size.width + 44, height: 56)
    fill.setFill()
    NSBezierPath(roundedRect: rect, xRadius: 28, yRadius: 28).fill()
    label.draw(at: NSPoint(x: x + 22, y: y + (56 - size.height) / 2))
    return rect.maxX
}

// og.png
render(1200, 630, "og.png") {
    cream.setFill()
    NSRect(x: 0, y: 0, width: 1200, height: 630).fill()
    peach.setFill()
    NSBezierPath(ovalIn: NSRect(x: 700, y: 60, width: 520, height: 520)).fill()
    color(0xd4a574, 0.35).setFill()
    for (x, y, r) in [(660.0, 520.0, 14.0), (1120.0, 90.0, 10.0), (620.0, 120.0, 8.0), (1150.0, 560.0, 12.0)] {
        NSBezierPath(ovalIn: NSRect(x: x - r, y: y - r, width: r * 2, height: r * 2)).fill()
    }
    monokun.draw(in: NSRect(x: 770, y: 130, width: 380, height: 380))

    text("ひとりで作る、アプリとゲーム", font("HiraginoSans-W6", 30), orangeInk, at: NSPoint(x: 80, y: 476))
    text("MonoSense", font("ArialRoundedMTBold", 116), ink, at: NSPoint(x: 72, y: 330), kern: -1)
    text("作ったアプリと、", font("HiraginoSans-W7", 44), ink, at: NSPoint(x: 80, y: 250))
    text("AI への指示をぜんぶ公開。", font("HiraginoSans-W7", 44), ink, at: NSPoint(x: 80, y: 190))

    let next = pill("X  @M0noSense", x: 80, y: 84, fill: orange, textColor: color(0x2b1a0e))
    _ = pill("note  MonoSense編集部", x: next + 16, y: 84, fill: color(0xffffff), textColor: ink)

    orange.setFill()
    NSRect(x: 0, y: 0, width: 1200, height: 16).fill()
}

// apple-touch-icon.png（iPhone は透明な所を黒で塗るので、クリーム色で埋める）
render(180, 180, "apple-touch-icon.png") {
    cream.setFill()
    NSRect(x: 0, y: 0, width: 180, height: 180).fill()
    monokun.draw(in: NSRect(x: 14, y: 14, width: 152, height: 152))
}

// favicon.png
render(64, 64, "favicon.png") {
    monokun.draw(in: NSRect(x: 0, y: 0, width: 64, height: 64))
}
