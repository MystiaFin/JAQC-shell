import QtQuick
import "../../components/common"
import "../../components/theme"

Rectangle {
    id: mediaControlButton

    required property string icon
    property bool primaryAction: false
    property bool active: false
    signal clicked()

    implicitWidth: primaryAction ? 48 : 38
    implicitHeight: primaryAction ? 48 : 38
    radius: primaryAction && active
        ? (buttonTap.pressed ? ShellMetrics.radiusSmall : ShellMetrics.radiusMedium)
        : height / 2
    color: primaryAction
        ? Theme.accentColor
        : buttonHover.hovered
            ? Theme.surfaceBorderColor
            : "transparent"
    opacity: enabled ? 1 : 0.35

    Behavior on opacity {
        MotionAnimation { type: MotionAnimation.DefaultEffects }
    }

    Behavior on radius {
        MotionAnimation { type: MotionAnimation.FastSpatial }
    }

    Text {
        anchors.centerIn: parent
        text: mediaControlButton.icon
        color: mediaControlButton.primaryAction
            ? Theme.accentTextColor
            : Theme.primaryTextColor
        font.family: Typography.nerdIconFontFamily
        font.pixelSize: mediaControlButton.primaryAction ? 21 : 18
    }

    HoverHandler {
        id: buttonHover
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        id: buttonTap
        onTapped: mediaControlButton.clicked()
    }
}
