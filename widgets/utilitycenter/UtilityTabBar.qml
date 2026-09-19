import QtQuick
import QtQuick.Layouts
import "../../components/common"
import "../../components/theme"

RowLayout {
    id: root

    required property string currentPage

    signal pageRequested(string page)

    spacing: 8

    Item { Layout.fillWidth: true }

    Repeater {
        model: [
            { page: "notifications", icon: Icons.notifications },
            { page: "wifi", icon: Icons.wifi },
            { page: "bluetooth", icon: Icons.bluetooth }
        ]

        Rectangle {
            id: tabButton

            required property var modelData
            readonly property bool active: root.currentPage === modelData.page

            implicitWidth: active ? 56 : 44
            Layout.preferredWidth: implicitWidth
            Layout.preferredHeight: 38
            radius: tabTap.pressed
                ? ShellMetrics.radiusSmall
                : active ? height / 2 : ShellMetrics.radiusMedium
            color: active
                ? Theme.accentColor
                : tabHover.hovered
                    ? Theme.surfaceBorderColor
                    : Theme.panelSurfaceColor

            Behavior on implicitWidth {
                MotionAnimation { type: MotionAnimation.FastSpatial }
            }

            Behavior on radius {
                MotionAnimation { type: MotionAnimation.FastSpatial }
            }

            Text {
                anchors.centerIn: parent
                text: tabButton.modelData.icon
                color: tabButton.active
                    ? Theme.accentTextColor
                    : Theme.primaryTextColor
                font.family: Typography.nerdIconFontFamily
                font.pixelSize: 18
            }

            HoverHandler {
                id: tabHover
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: tabTap
                onTapped: root.pageRequested(tabButton.modelData.page)
            }
        }
    }

    Item { Layout.fillWidth: true }
}
