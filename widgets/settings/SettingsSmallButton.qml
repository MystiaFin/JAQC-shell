import QtQuick
import "../../components/common"
import "../../components/theme"

Rectangle {
    id: root

    property string label
    property bool emphasized: false
    property bool transparent: false
    signal clicked

    width: ShellMetrics.compactControlHeight
    height: ShellMetrics.compactControlHeight
    radius: ShellMetrics.radiusMedium
    color: transparent ? "transparent" : Theme.surfaceContainerHighColor
    opacity: enabled ? 1 : 0.42
    activeFocusOnTab: true
    Accessible.role: Accessible.Button
    Accessible.name: label
    Accessible.onPressAction: if (enabled) clicked()

    StateLayer {
        anchors.fill: parent
        radius: parent.radius
        hovered: buttonHover.hovered
        pressed: buttonTap.pressed
        focused: root.activeFocus
        stateColor: root.emphasized ? Theme.accentColor : Theme.surfaceTextColor
    }

    Text {
        anchors.centerIn: parent
        text: root.label
        color: root.emphasized ? Theme.accentColor : Theme.primaryTextColor
        font.family: Typography.bodyFontFamily
        font.pixelSize: Typography.labelLarge
        font.weight: root.emphasized ? Font.DemiBold : Font.Normal
        font.capitalization: Font.Capitalize
    }

    HoverHandler {
        id: buttonHover
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: buttonTap
        enabled: root.enabled
        onTapped: root.clicked()
    }

    Keys.onSpacePressed: if (enabled) clicked()
    Keys.onReturnPressed: if (enabled) clicked()
}
