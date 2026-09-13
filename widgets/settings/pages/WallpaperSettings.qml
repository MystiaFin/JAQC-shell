import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsTextRow {
            width: parent.width
            title: "Wallpaper directory"
            detail: "Folder scanned by the wallpaper picker and shuffle timer"
            value: SettingsService.draftValue("wallpaperDirectory")
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("wallpaperDirectory", value)
        }
        SettingsChoiceRow {
            width: parent.width
            title: "Transition"
            detail: "Choose how the new wallpaper replaces the current one"
            value: SettingsService.draftValue("wallpaperTransitionType")
            options: [
                { value: "circle", label: "Circle" },
                { value: "fade", label: "Fade" },
                { value: "instant", label: "Instant" }
            ]
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("wallpaperTransitionType", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Transition duration"
            detail: "Duration used by wallpaper reveal and fade animations"
            value: SettingsService.draftValue("wallpaperDuration")
            minimum: 100; maximum: 3000; step: 100; decimals: 0; suffix: " ms"
            onValueRequested: value => SettingsService.setDraftValue("wallpaperDuration", value)
        }
    }

    SettingsGroup {
        SettingsToggleRow {
            width: parent.width
            title: "Random wallpaper"
            detail: "Automatically choose another image from the wallpaper directory"
            checked: SettingsService.draftValue("wallpaperShuffle")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("wallpaperShuffle", !checked)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Shuffle interval"
            detail: "How often a random wallpaper is selected"
            value: SettingsService.draftValue("wallpaperShuffleMinutes")
            minimum: 1; maximum: 180; step: 1; decimals: 0; suffix: " min"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("wallpaperShuffleMinutes", value)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Update colors with wallpaper"
            detail: "Rebuild the dynamic palette after a wallpaper change"
            checked: SettingsService.draftValue("wallpaperUpdatesPalette")
            onToggleRequested: SettingsService.setDraftValue("wallpaperUpdatesPalette", !checked)
        }
    }
}
