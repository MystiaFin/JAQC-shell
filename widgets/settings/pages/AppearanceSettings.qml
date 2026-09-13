import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsSliderRow {
            width: parent.width
            title: "UI scale"
            detail: "Scale the shell's shared spacing, radii, and major chrome"
            value: SettingsService.draftValue("uiScale")
            minimum: 0.80; maximum: 1.30; step: 0.05; decimals: 2; suffix: "×"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("uiScale", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Roundedness"
            detail: "Adjust the corner radius used across shell surfaces"
            value: SettingsService.draftValue("cornerRadiusScale")
            minimum: 0.50; maximum: 1.60; step: 0.05; decimals: 2; suffix: "×"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("cornerRadiusScale", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Blur strength"
            detail: "Control wallpaper blur behind overview and wallpaper surfaces"
            value: SettingsService.draftValue("blurStrength")
            minimum: 0; maximum: 1; step: 0.05; decimals: 2
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("blurStrength", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Surface opacity"
            detail: "Make shell surfaces more or less transparent"
            value: SettingsService.draftValue("surfaceOpacity")
            minimum: 0.60; maximum: 1; step: 0.02; decimals: 2
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("surfaceOpacity", value)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Reduce transparency"
            detail: "Force opaque surfaces and disable wallpaper blur"
            checked: SettingsService.draftValue("reduceTransparency")
            onToggleRequested: SettingsService.setDraftValue("reduceTransparency", !checked)
        }
    }
}
