import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsToggleRow {
            width: parent.width
            title: "Close launcher after launch"
            detail: "Dismiss the launcher after starting an app, tmux session, or palette"
            checked: SettingsService.draftValue("launcherCloseOnLaunch")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherCloseOnLaunch", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Escape clears launcher first"
            detail: "Clear a non-empty query before Escape closes the launcher"
            checked: SettingsService.draftValue("launcherEscapeClearsQuery")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue("launcherEscapeClearsQuery", !checked)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Click outside to dismiss"
            detail: "Let clicks outside open edge panels close the current overlay"
            checked: SettingsService.draftValue("clickOutsideDismiss")
            onToggleRequested: SettingsService.setDraftValue("clickOutsideDismiss", !checked)
        }
    }

    SettingsGroup {
        SettingsSliderRow {
            width: parent.width
            title: "Animation speed"
            detail: "Apply a global speed multiplier on top of per-group durations"
            value: SettingsService.draftValue("globalAnimationSpeed")
            minimum: 0.50; maximum: 2.0; step: 0.10; decimals: 1; suffix: "×"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("globalAnimationSpeed", value)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Reduce motion"
            detail: "Disable shell motion while preserving state changes"
            checked: SettingsService.draftValue("reduceMotion")
            onToggleRequested: SettingsService.setDraftValue("reduceMotion", !checked)
        }
    }
}
