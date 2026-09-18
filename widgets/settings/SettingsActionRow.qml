import QtQuick
import "../../components/theme"

Item {
    id: root

    required property string title
    required property string detail
    required property string actionLabel
    property bool danger: false
    property bool showSeparator: false
    signal actionRequested

    height: ShellMetrics.scaled(96)

    Column {
        anchors { left: parent.left; right: action.left; verticalCenter: parent.verticalCenter; leftMargin: ShellMetrics.spaceExtraLarge; rightMargin: ShellMetrics.spaceExtraLarge }
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

    SettingsActionButton {
        id: action
        anchors { right: parent.right; rightMargin: ShellMetrics.spaceExtraLarge; verticalCenter: parent.verticalCenter }
        label: root.actionLabel
        danger: root.danger
        onClicked: root.actionRequested()
    }

    Rectangle {
        visible: root.showSeparator
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: 20; rightMargin: 20 }
        height: 1
        color: Theme.surfaceBorderColor
        opacity: 0.65
    }
}
