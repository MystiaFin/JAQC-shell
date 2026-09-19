import QtQuick
import "../../components/common"
import "../../components/theme"

Item {
    id: root

    required property string title
    required property string detail
    required property string value
    required property var options
    property bool showSeparator: false
    property bool expanded: false
    signal valueRequested(string value)

    readonly property real closedHeight: ShellMetrics.scaled(96)
    readonly property real optionHeight: ShellMetrics.compactControlHeight
    readonly property real menuPadding: ShellMetrics.spaceExtraSmall

    function optionIndex(): int {
        for (let index = 0; index < options.length; index++) {
            const option = options[index];
            const optionValue = typeof option === "string" ? option : option.value;
            if (optionValue === value)
                return index;
        }
        return 0;
    }

    function optionLabel(): string {
        if (!options || options.length === 0)
            return value;
        const option = options[optionIndex()];
        return typeof option === "string" ? option : option.label;
    }

    function optionValue(option): string {
        return typeof option === "string" ? option : option.value;
    }

    function optionText(option): string {
        return typeof option === "string" ? option : option.label;
    }

    // The row never grows when the menu opens. The menu simply floats above
    // the rows below it, like a real dropdown.
    height: closedHeight
    z: expanded ? 100 : 0

    Column {
        anchors {
            left: parent.left
            right: selector.left
            verticalCenter: parent.verticalCenter
            leftMargin: ShellMetrics.spaceExtraLarge
            rightMargin: ShellMetrics.spaceExtraLarge
        }
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
        id: selector

        anchors {
            right: parent.right
            rightMargin: ShellMetrics.spaceExtraLarge
            verticalCenter: parent.verticalCenter
        }
        width: ShellMetrics.scaled(164)
        height: ShellMetrics.compactControlHeight
        radius: ShellMetrics.radiusMedium
        color: Theme.surfaceContainerHighColor
        border.width: root.expanded || activeFocus ? 2 : 0
        border.color: Theme.accentColor
        activeFocusOnTab: true
        Accessible.role: Accessible.ComboBox
        Accessible.name: root.title
        Accessible.description: root.detail

        StateLayer {
            anchors.fill: parent
            radius: parent.radius
            hovered: selectorHover.hovered
            pressed: selectorTap.pressed
            focused: selector.activeFocus
            stateColor: Theme.surfaceTextColor
        }

        Text {
            anchors {
                left: parent.left
                right: chevron.left
                verticalCenter: parent.verticalCenter
                leftMargin: ShellMetrics.spaceLarge
                rightMargin: ShellMetrics.spaceSmall
            }
            text: root.optionLabel()
            color: Theme.accentColor
            font.family: Typography.bodyFontFamily
            font.pixelSize: Typography.labelLarge
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }

        Text {
            id: chevron
            anchors {
                right: parent.right
                rightMargin: ShellMetrics.spaceMedium
                verticalCenter: parent.verticalCenter
            }
            text: root.expanded ? "󰅃" : "󰅀"
            color: Theme.secondaryTextColor
            font.family: Typography.nerdIconFontFamily
            font.pixelSize: Typography.titleSmall
        }

        HoverHandler {
            id: selectorHover
            cursorShape: Qt.PointingHandCursor
        }
        TapHandler {
            id: selectorTap
            onTapped: root.expanded = !root.expanded
        }
        Keys.onSpacePressed: root.expanded = !root.expanded
        Keys.onReturnPressed: root.expanded = !root.expanded
        Keys.onEscapePressed: root.expanded = false
    }

    Rectangle {
        id: dropdown

        // Keep it in the visual tree while the close animation finishes, but
        // disable all pointer handling as soon as the dropdown is closed.
        visible: root.expanded || opacity > 0.01
        enabled: root.expanded
        x: root.width - ShellMetrics.spaceExtraLarge - width
        y: selector.y + selector.height + ShellMetrics.spaceSmall
        width: selector.width
        height: optionsColumn.height + root.menuPadding * 2
        radius: ShellMetrics.radiusMedium
        color: Theme.surfaceContainerHighColor
        opacity: root.expanded ? 1 : 0
        scale: root.expanded ? 1 : 0.97
        transformOrigin: Item.TopRight
        z: 200

        Behavior on opacity {
            MotionAnimation { type: MotionAnimation.FastEffects }
        }
        Behavior on scale {
            MotionAnimation { type: MotionAnimation.FastEffects }
        }

        Column {
            id: optionsColumn
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: root.menuPadding
                rightMargin: root.menuPadding
                topMargin: root.menuPadding
            }

            Repeater {
                model: root.options

                delegate: Item {
                    id: optionItem

                    required property var modelData
                    width: optionsColumn.width
                    height: root.optionHeight
                    readonly property bool selected:
                        root.optionValue(modelData) === root.value

                    Rectangle {
                        anchors.fill: parent
                        radius: ShellMetrics.radiusSmall
                        color: optionItem.selected
                            ? Theme.selectedSurfaceColor
                            : (optionHover.hovered ? Theme.hoverSurfaceColor : "transparent")
                    }

                    Text {
                        anchors {
                            left: parent.left
                            right: check.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: 11
                            rightMargin: 7
                        }
                        text: root.optionText(optionItem.modelData)
                        color: optionItem.selected
                            ? Theme.accentColor
                            : Theme.primaryTextColor
                        font.family: Typography.bodyFontFamily
                        font.pixelSize: Typography.labelLarge
                        font.weight: optionItem.selected
                            ? Font.DemiBold
                            : Font.Normal
                        elide: Text.ElideRight
                    }

                    Text {
                        id: check
                        anchors {
                            right: parent.right
                            rightMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        visible: optionItem.selected
                        text: "󰄬"
                        color: Theme.accentColor
                        font.family: Typography.nerdIconFontFamily
                        font.pixelSize: 13
                    }

                    HoverHandler {
                        id: optionHover
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: {
                            root.valueRequested(root.optionValue(optionItem.modelData));
                            root.expanded = false;
                        }
                    }
                }
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
