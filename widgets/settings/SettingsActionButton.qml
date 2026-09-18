import QtQuick
import "../../components/common"
import "../../components/theme"

Rectangle {
    id: root

    required property string label
    property bool danger: false
    property bool primary: false
    signal clicked

    width: actionLabel.implicitWidth + ShellMetrics.spaceHuge
    height: ShellMetrics.compactControlHeight
    radius: ShellMetrics.radiusMedium
    color: danger ? Theme.dangerColor
        : (primary ? Theme.accentColor : Theme.surfaceContainerHighColor)
    opacity: enabled ? 1 : 0.42
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: label
    Accessible.onPressAction: if (enabled) clicked()

    StateLayer {
        anchors.fill: parent
        radius: parent.radius
        hovered: actionHover.hovered
        pressed: actionTap.pressed
        focused: root.activeFocus
        stateColor: root.danger ? Theme.dangerTextColor
            : root.primary ? Theme.accentTextColor : Theme.surfaceTextColor
    }

    Text {
        id: actionLabel

        anchors.centerIn: parent
        text: root.label
        color: root.danger ? Theme.dangerTextColor
            : root.primary ? Theme.accentTextColor : Theme.primaryTextColor
        font.family: Typography.bodyFontFamily
        font.pixelSize: Typography.labelLarge
        font.weight: Font.DemiBold
    }

    HoverHandler {
        id: actionHover
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: actionTap
        enabled: root.enabled
        onTapped: root.clicked()
    }

    Keys.onSpacePressed: if (enabled) clicked()
    Keys.onReturnPressed: if (enabled) clicked()
}
