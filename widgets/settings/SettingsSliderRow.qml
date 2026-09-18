import QtQuick
import "../../components/common"
import "../../components/theme"

Item {
    id: root

    required property string title
    required property string detail
    required property real value
    property real minimum: 0
    property real maximum: 1
    property real step: 0.05
    property int decimals: 2
    property string suffix: ""
    property bool showSeparator: false
    signal valueRequested(real value)

    function snapped(raw): real {
        const clamped = Math.max(minimum, Math.min(maximum, raw));
        if (step <= 0)
            return clamped;
        return Math.round((clamped - minimum) / step) * step + minimum;
    }

    function setFromX(xValue): void {
        const ratio = Math.max(0, Math.min(1, xValue / slider.width));
        valueRequested(snapped(minimum + ratio * (maximum - minimum)));
    }

    height: ShellMetrics.scaled(104)

    Column {
        anchors { left: parent.left; right: sliderWrap.left; verticalCenter: parent.verticalCenter; leftMargin: ShellMetrics.spaceExtraLarge; rightMargin: ShellMetrics.spaceExtraLarge }
        spacing: ShellMetrics.spaceExtraSmall
        Text {
            width: parent.width
            text: root.title
            color: Theme.primaryTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: Typography.titleMedium
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }
        Text {
            width: parent.width
            text: root.detail
            color: Theme.mutedTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: Typography.bodySmall
            elide: Text.ElideRight
        }
    }

    Row {
        id: sliderWrap
        anchors { right: parent.right; rightMargin: ShellMetrics.spaceExtraLarge; verticalCenter: parent.verticalCenter }
        spacing: ShellMetrics.spaceSmall

        Item {
            id: slider
            width: ShellMetrics.scaled(170)
            height: ShellMetrics.compactControlHeight
            activeFocusOnTab: true
            Accessible.role: Accessible.Slider
            Accessible.name: root.title

            Keys.onLeftPressed: root.valueRequested(root.snapped(root.value - root.step))
            Keys.onRightPressed: root.valueRequested(root.snapped(root.value + root.step))

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: ShellMetrics.scaled(4)
                radius: height / 2
                color: Theme.surfaceBorderColor

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(1,
                        (root.value - root.minimum) / (root.maximum - root.minimum)))
                    height: parent.height
                    radius: parent.radius
                    color: Theme.accentColor
                }
            }

            Rectangle {
                x: Math.max(0, Math.min(parent.width - width,
                    (parent.width - width) * ((root.value - root.minimum)
                        / (root.maximum - root.minimum))))
                anchors.verticalCenter: parent.verticalCenter
                width: sliderMouse.pressed || slider.activeFocus
                    ? ShellMetrics.scaled(20) : ShellMetrics.scaled(16)
                height: width
                radius: width / 2
                color: Theme.accentColor

                Behavior on width { MotionAnimation { type: MotionAnimation.FastEffects } }
            }

            MouseArea {
                id: sliderMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: mouse => root.setFromX(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        root.setFromX(mouse.x);
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: ShellMetrics.scaled(64)
            text: Number(root.value).toFixed(root.decimals) + root.suffix
            color: Theme.secondaryTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: Typography.labelMedium
            horizontalAlignment: Text.AlignRight
        }
    }

    Rectangle {
        visible: root.showSeparator
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: 20; rightMargin: 20 }
        height: 1
        color: Theme.surfaceBorderColor
        opacity: 0.65
    }
}
