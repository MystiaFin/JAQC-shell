import QtQuick
import ".."
import "../../../services"

Column {
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsChoiceRow {
            width: parent.width
            title: "Visibility"
            detail: "Show widgets only on an empty desktop, always, or never"
            value: SettingsService.draftValue("floatingWidgetVisibilityMode")
            options: [
                { value: "desktop", label: "Desktop only" },
                { value: "always", label: "Always" },
                { value: "hidden", label: "Hidden" }
            ]
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("floatingWidgetVisibilityMode", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Widget scale"
            detail: "Scale desktop cards while keeping automatic placement"
            value: SettingsService.draftValue("floatingWidgetScale")
            minimum: 0.70; maximum: 1.35; step: 0.05; decimals: 2; suffix: "×"
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("floatingWidgetScale", value)
        }
        SettingsSliderRow {
            width: parent.width
            title: "Opacity"
            detail: "Adjust the opacity of the complete desktop widget layer"
            value: SettingsService.draftValue("floatingWidgetOpacity")
            minimum: 0.35; maximum: 1.0; step: 0.05; decimals: 2
            showSeparator: true
            onValueRequested: value => SettingsService.setDraftValue("floatingWidgetOpacity", value)
        }
        SettingsToggleRow {
            width: parent.width
            title: "Lock placement"
            detail: "Keep the current automatic placement instead of recomputing it"
            checked: SettingsService.draftValue("floatingWidgetLockPlacement")
            onToggleRequested: SettingsService.setDraftValue("floatingWidgetLockPlacement", !checked)
        }
    }

    SettingsGroup {
        SettingsToggleRow { width: parent.width; title: "Clock"; detail: "Large desktop clock"; checked: SettingsService.draftValue("clockWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("clockWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "Weather"; detail: "Current weather summary"; checked: SettingsService.draftValue("weatherWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("weatherWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "Calendar"; detail: "Monthly calendar"; checked: SettingsService.draftValue("calendarWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("calendarWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "CPU temperature"; detail: "Processor thermal card"; checked: SettingsService.draftValue("cpuTemperatureWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("cpuTemperatureWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "CPU usage"; detail: "Processor utilization card"; checked: SettingsService.draftValue("cpuUsageWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("cpuUsageWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "GPU temperature"; detail: "Shown only when a supported GPU is available"; checked: SettingsService.draftValue("gpuTemperatureWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("gpuTemperatureWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "UV index"; detail: "Requires configured weather data"; checked: SettingsService.draftValue("uvIndexWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("uvIndexWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "Humidity"; detail: "Requires configured weather data"; checked: SettingsService.draftValue("humidityWidget"); showSeparator: true; onToggleRequested: SettingsService.setDraftValue("humidityWidget", !checked) }
        SettingsToggleRow { width: parent.width; title: "Air quality"; detail: "Shown only when air-quality data is available"; checked: SettingsService.draftValue("airQualityWidget"); onToggleRequested: SettingsService.setDraftValue("airQualityWidget", !checked) }
    }
}
