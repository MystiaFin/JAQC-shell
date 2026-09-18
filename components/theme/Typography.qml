pragma Singleton

import Quickshell
import "../../services"

Singleton {
    readonly property string bodyFontFamily: "Poppins"
    readonly property string nerdIconFontFamily: "JetBrains Mono Nerd Font"
    readonly property string materialIconFontFamily: "Material Design Icons"
    readonly property string symbolIconFontFamily: "Symbols Nerd Font"

    readonly property real labelSmall: 11 * SettingsService.uiScale
    readonly property real labelMedium: 12 * SettingsService.uiScale
    readonly property real labelLarge: 13 * SettingsService.uiScale
    readonly property real bodySmall: 12 * SettingsService.uiScale
    readonly property real bodyMedium: 14 * SettingsService.uiScale
    readonly property real bodyLarge: 16 * SettingsService.uiScale
    readonly property real titleSmall: 14 * SettingsService.uiScale
    readonly property real titleMedium: 16 * SettingsService.uiScale
    readonly property real titleLarge: 20 * SettingsService.uiScale
    readonly property real headlineSmall: 24 * SettingsService.uiScale
}
