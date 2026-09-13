import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../components/theme"

Item {
    id: root

    required property string displayName
    required property string accountName
    required property string profileSource
    property bool customPicture: false
    signal changeRequested
    signal clearRequested

    height: 128

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 16

        ClippingRectangle {
            Layout.preferredWidth: 72
            Layout.preferredHeight: 72
            radius: width / 2
            color: Theme.selectedSurfaceColor

            Image {
                id: avatar
                anchors.fill: parent
                source: root.profileSource
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                visible: avatar.status !== Image.Ready
                text: "󰀄"
                color: Theme.secondaryTextColor
                font.family: Typography.nerdIconFontFamily
                font.pixelSize: 32
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                Layout.fillWidth: true
                text: root.displayName
                color: Theme.primaryTextColor
                font.family: Typography.bodyFontFamily
                font.pixelSize: 17
                font.weight: Font.DemiBold
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: "@" + root.accountName
                color: Theme.mutedTextColor
                font.family: Typography.bodyFontFamily
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: "Used by the lock screen"
                color: Theme.secondaryTextColor
                font.family: Typography.bodyFontFamily
                font.pixelSize: 11
                elide: Text.ElideRight
            }
        }

        RowLayout {
            spacing: 8

            SettingsActionButton {
                visible: root.customPicture
                label: "Default"
                onClicked: root.clearRequested()
            }

            SettingsActionButton {
                label: "Change photo"
                onClicked: root.changeRequested()
            }
        }
    }
}
