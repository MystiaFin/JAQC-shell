import QtQuick
import "../../components/common"
import "../../components/theme"
import "../../services"

Item {
    id: root

    required property string groupKey
    required property string title
    required property string detail
    property bool showSeparator: false

    readonly property string styleKey: groupKey + "Animation"
    readonly property string durationKey: groupKey + "Duration"

    height: 104

    Column {
        anchors {
            left: parent.left
            right: controls.left
            verticalCenter: parent.verticalCenter
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 3

        Text {
            width: parent.width
            text: root.title
            color: Theme.primaryTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: 16
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.detail
            color: Theme.mutedTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: 12
            elide: Text.ElideRight
        }
    }

    Row {
        id: controls

        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        spacing: 8

        SettingsSmallButton {
            width: 96
            label: SettingsService.draftValue(root.styleKey)
            emphasized: true
            onClicked: {
                const styles = ["off", "fade", "spatial", "spring"];
                const current = styles.indexOf(SettingsService.draftValue(root.styleKey));
                SettingsService.setDraftValue(
                    root.styleKey,
                    styles[(current + 1) % styles.length]);
            }
        }

        Rectangle {
            width: 150
            height: 36
            radius: ShellMetrics.radiusMedium
            color: Theme.selectedSurfaceColor

            SettingsSmallButton {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 2
                }
                width: 36
                height: 36
                label: "−"
                transparent: true
                onClicked: SettingsService.setDraftValue(
                    root.durationKey,
                    Math.max(0, SettingsService.draftValue(root.durationKey) - 50))
            }

            Text {
                anchors.centerIn: parent
                width: 78
                text: SettingsService.draftValue(root.durationKey) + " ms"
                color: Theme.secondaryTextColor
                font.family: Typography.bodyFontFamily
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
            }

            SettingsSmallButton {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 2
                }
                width: 36
                height: 36
                label: "+"
                transparent: true
                onClicked: SettingsService.setDraftValue(
                    root.durationKey,
                    Math.min(5000, SettingsService.draftValue(root.durationKey) + 50))
            }
        }
    }

    Rectangle {
        visible: root.showSeparator
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 20
            rightMargin: 20
        }
        height: 1
        color: Theme.surfaceBorderColor
        opacity: 0.65
    }
}
