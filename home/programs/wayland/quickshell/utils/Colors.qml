pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // Catppuccin Mocha colors
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color overlay2: "#9399b2"
    readonly property color text: "#cdd6f4"
    readonly property color subtext0: "#a6adc8"
    readonly property color subtext1: "#bac2de"

    // Catppuccin accent colors
    readonly property color rosewater: "#f5e0dc"
    readonly property color flamingo: "#f2cdcd"
    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color sapphire: "#74c7ec"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"

    readonly property color accent: mauve

    // Bar specific colors
    readonly property color bgBar: mantle
    readonly property color bgBlur: Qt.rgba(surface0.r, surface0.g, surface0.b, 0.8)
    readonly property color bg: base
    readonly property color foreground: text
    readonly property color foregroundBlur: Qt.rgba(text.r, text.g, text.b, 0.7)
    readonly property color windowShadow: Qt.rgba(crust.r, crust.g, crust.b, 0.5)

    // Workspace colors
    readonly property list<color> monitorColors: [pink, mauve, blue, lavender]

    // Button states
    readonly property color buttonEnabled: accent
    readonly property color buttonEnabledHover: Qt.lighter(accent, 1.1)
    readonly property color buttonDisabled: surface1
    readonly property color buttonDisabledHover: surface2

    // Additional semantic colors
    readonly property color surface: surface0
    readonly property color overlay: overlay0
    readonly property color active: accent
    readonly property color inactive: surface1
    readonly property color hover: surface2
}
