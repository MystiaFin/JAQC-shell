import QtQuick
import "../theme"

Rectangle {
    property bool hovered: false
    property bool pressed: false
    property bool focused: false
    property color stateColor: Theme.surfaceTextColor

    color: stateColor
    opacity: pressed ? 0.12 : focused ? 0.10 : hovered ? 0.08 : 0

    Behavior on opacity {
        MotionAnimation { type: MotionAnimation.FastEffects }
    }
}
