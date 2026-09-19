import QtQuick
import "../../components/theme"

Item {
    id: root

    required property string title
    required property string detail
    required property string value
    property bool showSeparator: false
    signal valueRequested(string value)

    height: ShellMetrics.scaled(104)

    Column {
        anchors { left: parent.left; right: editor.left; verticalCenter: parent.verticalCenter; leftMargin: ShellMetrics.spaceExtraLarge; rightMargin: ShellMetrics.spaceExtraLarge }
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

    Rectangle {
        id: editor
        anchors { right: parent.right; rightMargin: ShellMetrics.spaceExtraLarge; verticalCenter: parent.verticalCenter }
        width: Math.min(ShellMetrics.scaled(280), root.width * 0.42)
        height: ShellMetrics.compactControlHeight
        radius: ShellMetrics.radiusMedium
        color: Theme.surfaceContainerHighColor
        border.width: input.activeFocus ? 2 : 0
        border.color: Theme.accentColor

        TextInput {
            id: input
            anchors { fill: parent; leftMargin: ShellMetrics.spaceMedium; rightMargin: ShellMetrics.spaceMedium }
            text: root.value
            color: Theme.primaryTextColor
            selectionColor: Theme.accentColor
            selectedTextColor: Theme.accentTextColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: Typography.bodyMedium
            verticalAlignment: TextInput.AlignVCenter
            clip: true
            onTextEdited: root.valueRequested(text)
            onEditingFinished: focus = false
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
