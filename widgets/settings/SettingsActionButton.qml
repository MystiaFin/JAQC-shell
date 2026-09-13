import QtQuick
import "../../components/common"
import "../../components/theme"

Rectangle {
    id: root

    required property string label
    property bool danger: false
    property bool primary: false
    signal clicked

    width: actionLabel.implicitWidth + 28
    height: 40
    radius: ShellMetrics.radiusMedium
    color: danger ? Theme.dangerColor
        : (primary ? Theme.accentColor : Theme.selectedSurfaceColor)
    opacity: enabled ? 1 : 0.42

    Text {
        id: actionLabel

        anchors.centerIn: parent
        text: root.label
        color: root.danger || root.primary
            ? Theme.accentTextColor : Theme.primaryTextColor
        font.family: Typography.bodyFontFamily
        font.pixelSize: 12
        font.weight: Font.DemiBold
    }

    HoverHandler {
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        enabled: root.enabled
        onTapped: root.clicked()
    }
}
