import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsToggleRow {
            width: parent.width
            title: "Lock screen after idle"
            detail: "Automatically lock the session after a period of inactivity"
            checked: SettingsService.draftValue("idleLockEnabled")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue(
                "idleLockEnabled", !checked)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Lock timeout"
            detail: "Minutes of inactivity before the screen locks"
            value: SettingsService.draftValue("idleLockMinutes")
            minimum: 1; maximum: 60; step: 1; decimals: 0; suffix: " min"
            onValueRequested: value => SettingsService.setDraftValue(
                "idleLockMinutes", value)
        }
    }

    SettingsGroup {
        SettingsToggleRow {
            width: parent.width
            title: "Suspend after idle"
            detail: "Lock the session and suspend the system after inactivity"
            checked: SettingsService.draftValue("idleSleepEnabled")
            showSeparator: true
            onToggleRequested: SettingsService.setDraftValue(
                "idleSleepEnabled", !checked)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Suspend timeout"
            detail: "Minutes of inactivity before the system suspends"
            value: SettingsService.draftValue("idleSleepMinutes")
            minimum: 1; maximum: 120; step: 1; decimals: 0; suffix: " min"
            onValueRequested: value => SettingsService.setDraftValue(
                "idleSleepMinutes", value)
        }
    }
}
