pragma Singleton

import Quickshell
import QtQuick
import "../../services"
import "palettes"

Singleton {
    readonly property string currentTheme: SettingsService.theme

    readonly property QtObject catppuccin: Catppuccin {}
    readonly property QtObject gruvbox: Gruvbox {}
    readonly property QtObject dynamic: Dynamic {}

    readonly property var availableThemes: [
        { id: "dynamic", name: "Dynamic" },
        { id: "gruvbox", name: "Gruvbox" },
        { id: "catppuccin", name: "Catppuccin" }
    ]

    function setTheme(themeId: string): void {
        const exists = availableThemes.some(theme => theme.id === themeId);
        if (exists)
            SettingsService.setValue("theme", themeId);
    }

    function withOpacity(colorValue: color, opacityValue: real): color {
        return Qt.rgba(colorValue.r, colorValue.g, colorValue.b,
            Math.max(0, Math.min(1, opacityValue)));
    }

    function mix(first: color, second: color, amount: real): color {
        return Qt.rgba(
            first.r + (second.r - first.r) * amount,
            first.g + (second.g - first.g) * amount,
            first.b + (second.b - first.b) * amount,
            first.a + (second.a - first.a) * amount
        );
    }

    function linearChannel(channel: real): real {
        return channel <= 0.04045 ? channel / 12.92
            : Math.pow((channel + 0.055) / 1.055, 2.4);
    }

    function luminance(colorValue: color): real {
        return linearChannel(colorValue.r) * 0.2126
            + linearChannel(colorValue.g) * 0.7152
            + linearChannel(colorValue.b) * 0.0722;
    }

    function contrastText(background: color): color {
        const dark = "#171218";
        const light = "#fff8fb";
        const backgroundLuminance = luminance(background);
        const darkRatio = (backgroundLuminance + 0.05) / (luminance(dark) + 0.05);
        const lightRatio = (luminance(light) + 0.05) / (backgroundLuminance + 0.05);
        return darkRatio >= lightRatio ? dark : light;
    }

    readonly property bool dynamicActive: currentTheme === "dynamic"
    readonly property QtObject activeTheme: dynamicActive
        ? dynamic : currentTheme === "gruvbox" ? gruvbox : catppuccin
    readonly property real surfaceOpacity: SettingsService.reduceTransparency
        ? 1 : SettingsService.surfaceOpacity

    readonly property color liquidColor: activeTheme.foregroundColor
    readonly property color windowColor: activeTheme.windowColor
    readonly property color maskColor: activeTheme.maskColor
    readonly property color wallpaperFallbackColor: activeTheme.wallpaperFallbackColor

    readonly property color shellBackgroundColor: activeTheme.foregroundColor
    readonly property color shellShadowColor: "#50000000"
    readonly property color panelSurfaceColor: withOpacity(
        activeTheme.searchBackgroundColor, surfaceOpacity)
    readonly property color hoverSurfaceColor: activeTheme.itemHoverColor
    readonly property color surfaceBorderColor: activeTheme.searchBorderColor
    readonly property color selectedSurfaceColor: activeTheme.highlightColor
    readonly property color primaryTextColor: activeTheme.textColor
    readonly property color secondaryTextColor: activeTheme.secondaryTextColor
    readonly property color mutedTextColor: activeTheme.placeholderTextColor
    readonly property color accentColor: activeTheme.accentColor
    readonly property color accentHoverColor: activeTheme.accentHoverColor
    readonly property color accentTextColor: activeTheme.accentTextColor
    readonly property color statusAccentColor: lightMode
        ? mix(accentColor, "#000000", 0.22) : accentColor
    readonly property color statusAccentTextColor: contrastText(statusAccentColor)
    readonly property color successColor: activeTheme.successColor
    readonly property color dangerColor: activeTheme.dangerColor
    readonly property color dangerTextColor: contrastText(dangerColor)

    // Material-inspired tonal surface hierarchy. Existing aliases above remain
    // available while components migrate to explicit semantic roles.
    readonly property color surfaceColor: panelSurfaceColor
    readonly property color surfaceContainerLowColor: mix(
        activeTheme.foregroundColor, activeTheme.searchBackgroundColor, 0.55)
    readonly property color surfaceContainerColor: activeTheme.searchBackgroundColor
    readonly property color surfaceContainerHighColor: mix(
        activeTheme.searchBackgroundColor, activeTheme.textColor, lightMode ? 0.08 : 0.06)
    readonly property color surfaceTextColor: primaryTextColor
    readonly property color surfaceVariantTextColor: secondaryTextColor
    readonly property color outlineColor: surfaceBorderColor
    readonly property color outlineVariantColor: withOpacity(surfaceBorderColor, 0.62)
    readonly property color primaryContainerColor: selectedSurfaceColor
    readonly property color primaryContainerTextColor: accentColor
    readonly property color scrimColor: "#99000000"
    readonly property bool lightMode: dynamicActive && dynamic.lightMode

    function toggleColorMode(): void {
        if (!dynamicActive)
            return;

        const next = dynamic.lightMode ? "dark" : "light";
        SettingsService.setValue("colorMode", next);
    }
}
