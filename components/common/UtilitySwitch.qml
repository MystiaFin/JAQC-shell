import QtQuick
import "../theme"

Rectangle {
    id: root

    property bool checked: false
    property string accessibleName: ""
    signal toggled()

    implicitWidth: ShellMetrics.scaled(48)
    implicitHeight: ShellMetrics.scaled(28)
    radius: height / 2
    color: checked ? Theme.accentColor : Theme.surfaceContainerHighColor
    border.width: checked ? 0 : 2
    border.color: Theme.outlineColor
    opacity: enabled ? 1 : 0.42
    activeFocusOnTab: true
    Accessible.role: Accessible.CheckBox
    Accessible.name: accessibleName
    Accessible.checked: checked
    Accessible.onToggleAction: if (enabled) toggled()

    StateLayer {
        anchors.fill: parent
        radius: parent.radius
        hovered: switchHover.hovered
        pressed: switchTap.pressed
        focused: root.activeFocus
        stateColor: root.checked ? Theme.accentTextColor : Theme.surfaceTextColor
    }

    Rectangle {
        width: root.checked ? ShellMetrics.scaled(24) : ShellMetrics.scaled(16)
        height: width
        radius: width / 2
        y: (root.height - height) / 2
        x: root.checked ? root.width - width - ShellMetrics.scaled(2)
            : ShellMetrics.scaled(6)
        color: root.checked ? Theme.accentTextColor : Theme.surfaceVariantTextColor

        Behavior on x {
            MotionAnimation { type: MotionAnimation.FastSpatial }
        }
    }

    HoverHandler {
        id: switchHover
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        id: switchTap
        enabled: root.enabled
        onTapped: root.toggled()
    }

    Keys.onSpacePressed: if (enabled) toggled()
    Keys.onReturnPressed: if (enabled) toggled()
}
