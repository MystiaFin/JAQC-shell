import Quickshell
import Quickshell.Widgets
import QtQuick
import "../../components/common"
import "../../components/theme"
import "../../services"

Item {
    id: root

    required property var result
    property bool selected: false

    signal activated

    Rectangle {
        anchors.fill: parent
        radius: ShellMetrics.radiusMedium
        color: Theme.hoverSurfaceColor
        opacity: hoverHandler.hovered && !root.selected ? 1 : 0

        Behavior on opacity {
            MotionAnimation {
                group: "launcher"
                type: MotionAnimation.FastEffects
            }
        }
    }

    IconImage {
        id: applicationIcon

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 12
        }

        implicitSize: 38
        visible: SettingsService.launcherShowIcons
            && root.result.type === "application"
        source: visible
            ? Quickshell.iconPath(root.result.application.icon,
                "application-x-executable") : ""
        asynchronous: true
    }

    Text {
        id: commandIcon

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 12
        }

        width: 38
        visible: SettingsService.launcherShowIcons
            && root.result.type === "command"
        text: visible ? root.result.icon : ""
        color: Theme.primaryTextColor
        font.family: Typography.nerdIconFontFamily
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: colorSchemeIcon

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 20
        }

        width: 22
        height: 22
        radius: width / 2
        visible: SettingsService.launcherShowIcons
            && root.result.type === "colorScheme"
        color: root.result.themeId === "gruvbox"
            ? Theme.gruvbox.accentColor : Theme.catppuccin.accentColor
        border.color: Theme.surfaceBorderColor
        border.width: 1

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: width / 2
            visible: root.result.themeId === "dynamic"
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#f2a7c3" }
                GradientStop { position: 0.25; color: "#f7c89b" }
                GradientStop { position: 0.5; color: "#a8dfc4" }
                GradientStop { position: 0.75; color: "#9fc9ee" }
                GradientStop { position: 1.0; color: "#c5afe8" }
            }
        }
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: SettingsService.launcherShowIcons
                && (root.result.type === "application"
                    || root.result.type === "command"
                    || root.result.type === "colorScheme") ? 62 : 12
            rightMargin: 12
        }
        spacing: SettingsService.launcherShowDescriptions ? 1 : 0

        Text {
            width: parent.width
            text: root.result.name
            color: Theme.primaryTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: 15
            font.weight: Font.Normal
            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Text {
            width: parent.width
            visible: SettingsService.launcherShowDescriptions
                && root.result.detail !== undefined
                && root.result.detail !== ""
            text: visible ? root.result.detail : ""
            color: Theme.mutedTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: 10
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler { onTapped: root.activated() }
}
