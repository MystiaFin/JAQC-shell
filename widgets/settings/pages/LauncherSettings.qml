import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsSliderRow {
            width: parent.width
            title: "Launcher width"
            detail: "Set the preferred launcher panel width"
            value: SettingsService.draftValue("launcherWidth")
            minimum: 420; maximum: 900; step: 20; decimals: 0; suffix: " px"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("launcherWidth", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Visible results"
            detail: "Limit how many rows are shown before the list scrolls"
            value: SettingsService.draftValue("launcherVisibleRows")
            minimum: 3; maximum: 14; step: 1; decimals: 0
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("launcherVisibleRows", value)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Application descriptions"
            detail: "Show generic names or application comments below results"
            checked: SettingsService.draftValue("launcherShowDescriptions")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherShowDescriptions", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Result icons"
            detail: "Show application and command icons"
            checked: SettingsService.draftValue("launcherShowIcons")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherShowIcons", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Remember query"
            detail: "Keep the last search when the launcher is reopened normally"
            checked: SettingsService.draftValue("launcherRememberQuery")
            onToggleRequested: SettingsService.setDraftValue("launcherRememberQuery", !checked)
        }
    }

    SettingsGroup {
        SettingsToggleRow {
            width: parent.width
            title: "Command mode"
            detail: "Enable the > command palette prefix"
            checked: SettingsService.draftValue("launcherCommandMode")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherCommandMode", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Settings command"
            detail: "Show Settings in command mode"
            checked: SettingsService.draftValue("launcherCommandSettings")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherCommandSettings", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Color scheme command"
            detail: "Show Color scheme in command mode"
            checked: SettingsService.draftValue("launcherCommandColors")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherCommandColors", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Tmux command"
            detail: "Show Tmux sessions in command mode"
            checked: SettingsService.draftValue("launcherCommandTmux")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherCommandTmux", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Wallpaper command"
            detail: "Show Wallpapers in command mode"
            checked: SettingsService.draftValue("launcherCommandWallpapers")
            onToggleRequested: SettingsService.setDraftValue("launcherCommandWallpapers", !checked)
        }
    }
}
