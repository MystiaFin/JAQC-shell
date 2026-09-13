import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../common"
import "../state"
import "../theme"
import "../../services"

WlSessionLockSurface {
    id: root

    required property var controller

    property date now: new Date()
    property bool awake: false
    property bool passwordVisible: false
    property real shakeOffset: 0
    property bool entered: false
    readonly property bool exiting: LockState.phase === "unlocking"
        || LockState.phase === "revealHold"
        || LockState.phase === "revealing"
    readonly property int transitionDuration: LockState.scaledDuration(260)

    readonly property string wallpaperSource: {
        const outputName = root.screen ? root.screen.name : "";
        const displayed = outputName !== ""
            ? DisplayedWallpaperState.sourceForScreen(outputName) : "";
        return displayed !== "" ? displayed : WallpaperService.source.toString();
    }
    readonly property string timeText: SettingsService.clock24Hour
        ? Qt.formatDateTime(now, "HH:mm")
        : Qt.formatDateTime(now, "hh:mm AP")
    readonly property string dateText: Qt.formatDateTime(now, "dddd, d MMMM")
    readonly property bool unlockVisible: awake
        || passwordInput.text.length > 0 || controller.authenticating

    color: Theme.wallpaperFallbackColor

    function wake(): void {
        awake = true;
        idleTimer.restart();
    }

    function submit(): void {
        if (controller.authenticating || passwordInput.text.length === 0)
            return;
        controller.authenticate(passwordInput.text);
    }

    Image {
        anchors.fill: parent
        source: root.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
        cache: true
    }

    Rectangle {
        id: dimLayer
        anchors.fill: parent
        color: "black"
        opacity: root.exiting ? 0.06 : 0.48

        Behavior on opacity {
            NumberAnimation {
                duration: root.transitionDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        id: gradientLayer
        anchors.fill: parent
        opacity: root.exiting ? 0.12 : 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#18000000" }
            GradientStop { position: 0.58; color: "#08000000" }
            GradientStop { position: 1.0; color: "#3d000000" }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.transitionDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    FocusScope {
        id: focusRoot
        anchors.fill: parent
        focus: true
        opacity: root.entered && !root.exiting ? 1 : 0
        transform: Translate {
            y: root.entered && !root.exiting ? 0 : 8

            Behavior on y {
                NumberAnimation {
                    duration: root.transitionDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.transitionDuration
                easing.type: Easing.OutCubic
            }
        }

        Column {
            id: clockBlock
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: Math.max(72, parent.height * 0.18)
            }
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.timeText
                color: "#f7f7f7"
                font.family: Typography.bodyFontFamily
                font.pixelSize: Math.min(112, Math.max(78, root.width * 0.075))
                font.weight: Font.Medium
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.dateText
                color: "#d9ffffff"
                font.family: Typography.bodyFontFamily
                font.pixelSize: 16
                font.weight: Font.Medium
            }
        }

        Item {
            id: unlockArea
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: clockBlock.bottom
                topMargin: 36
            }
            width: Math.min(430, parent.width - 48)
            height: 190
            opacity: root.unlockVisible ? 1 : 0
            transform: Translate {
                x: root.shakeOffset
                y: root.unlockVisible ? 0 : 10

                Behavior on y {
                    MotionAnimation { type: MotionAnimation.FastSpatial }
                }
            }

            Behavior on opacity {
                MotionAnimation { type: MotionAnimation.DefaultEffects }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: 12

                ClippingRectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 72
                    height: 72
                    radius: width / 2
                    color: "#4d000000"

                    Image {
                        id: profileImage
                        anchors.fill: parent
                        source: SettingsService.profilePictureSource
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        smooth: true
                        visible: status === Image.Ready
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: profileImage.status !== Image.Ready
                        text: "󰀄"
                        color: "#f4ffffff"
                        font.family: Typography.nerdIconFontFamily
                        font.pixelSize: 34
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: SettingsService.effectiveDisplayName
                    color: "#f7f7f7"
                    font.family: Typography.bodyFontFamily
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(360, parent.width)
                    height: 50
                    radius: ShellMetrics.radiusLarge
                    color: "#b021252b"
                    border.width: passwordInput.activeFocus ? 1 : 0
                    border.color: Theme.accentColor

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: 16
                            verticalCenter: parent.verticalCenter
                        }
                        visible: passwordInput.text.length === 0
                        text: controller.authenticating
                            ? "Authenticating…" : "Password"
                        color: "#aaffffff"
                        font.family: Typography.bodyFontFamily
                        font.pixelSize: 13
                    }

                    TextInput {
                        id: passwordInput
                        anchors {
                            left: parent.left
                            right: revealButton.left
                            top: parent.top
                            bottom: parent.bottom
                            leftMargin: 16
                            rightMargin: 8
                        }
                        enabled: !controller.authenticating
                        color: "#f7f7f7"
                        selectionColor: Theme.accentColor
                        selectedTextColor: Theme.accentTextColor
                        font.family: Typography.bodyFontFamily
                        font.pixelSize: 14
                        verticalAlignment: TextInput.AlignVCenter
                        echoMode: root.passwordVisible
                            ? TextInput.Normal : TextInput.Password
                        inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                        passwordCharacter: "•"
                        clip: true
                        focus: true

                        onTextChanged: root.wake()
                        onAccepted: root.submit()
                        Keys.onEscapePressed: {
                            text = "";
                            root.awake = false;
                        }
                    }

                    Item {
                        id: revealButton
                        anchors {
                            right: parent.right
                            rightMargin: 7
                            verticalCenter: parent.verticalCenter
                        }
                        width: 38
                        height: 38

                        Text {
                            anchors.centerIn: parent
                            text: root.passwordVisible
                                ? Icons.passwordVisible : Icons.passwordHidden
                            color: "#c8ffffff"
                            font.family: Typography.nerdIconFontFamily
                            font.pixelSize: 17
                        }

                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                        TapHandler {
                            onTapped: {
                                root.passwordVisible = !root.passwordVisible;
                                passwordInput.forceActiveFocus();
                            }
                        }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 18
                    text: controller.authMessage
                    visible: text.length > 0
                    color: controller.authMessageIsError
                        ? "#ffff9c9c" : "#c8ffffff"
                    font.family: Typography.bodyFontFamily
                    font.pixelSize: 11
                }
            }
        }

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 28
            }
            visible: !root.unlockVisible
            text: Icons.lock + "   Type your password to unlock"
            color: "#b8ffffff"
            font.family: Typography.bodyFontFamily
            font.pixelSize: 11
        }

        Rectangle {
            id: mediaCard
            visible: MediaService.available
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: 28
                bottomMargin: 24
            }
            width: Math.min(360, root.width * 0.32)
            height: 72
            radius: ShellMetrics.radiusExtraLarge
            color: "#9c17191f"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                ClippingRectangle {
                    Layout.preferredWidth: 52
                    Layout.preferredHeight: 52
                    radius: ShellMetrics.radiusMedium
                    color: "#2fffffff"

                    Image {
                        anchors.fill: parent
                        source: MediaService.artUrl
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        smooth: true
                        visible: MediaService.artUrl !== ""
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: MediaService.artUrl === ""
                        text: Icons.media
                        color: "#d9ffffff"
                        font.family: Typography.nerdIconFontFamily
                        font.pixelSize: 22
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        Layout.fillWidth: true
                        text: MediaService.title
                        color: "#f7f7f7"
                        font.family: Typography.bodyFontFamily
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }
                    Text {
                        Layout.fillWidth: true
                        text: MediaService.artist
                        color: "#b8ffffff"
                        font.family: Typography.bodyFontFamily
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                }

                Item {
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 34
                    enabled: MediaService.canTogglePlaying

                    Text {
                        anchors.centerIn: parent
                        text: MediaService.playing ? Icons.pause : Icons.play
                        color: parent.enabled ? "#f7f7f7" : "#6affffff"
                        font.family: Typography.nerdIconFontFamily
                        font.pixelSize: 18
                    }
                    HoverHandler {
                        enabled: parent.enabled
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        enabled: parent.enabled
                        onTapped: MediaService.playPause()
                    }
                }
            }
        }

        Row {
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 28
                bottomMargin: 30
            }
            spacing: 16

            Row {
                spacing: 7
                Text {
                    text: NetworkService.connectedNetwork
                        ? Icons.wifiStrong : Icons.wifiNone
                    color: "#d9ffffff"
                    font.family: Typography.nerdIconFontFamily
                    font.pixelSize: 15
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: NetworkService.connectedNetwork
                        ? NetworkService.connectedNetwork.name : "Offline"
                    color: "#c8ffffff"
                    font.family: Typography.bodyFontFamily
                    font.pixelSize: 10
                }
            }

            Row {
                visible: BatteryService.available
                spacing: 7
                Text {
                    text: BatteryService.icon
                    color: "#d9ffffff"
                    font.family: Typography.nerdIconFontFamily
                    font.pixelSize: 15
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: BatteryService.percent + "%"
                    color: "#c8ffffff"
                    font.family: Typography.bodyFontFamily
                    font.pixelSize: 10
                }
            }
        }

        HoverHandler {
            onPointChanged: root.wake()
        }

        Connections {
            target: root.controller

            function onFailureSerialChanged(): void {
                passwordInput.text = "";
                root.wake();
                shakeAnimation.restart();
                Qt.callLater(() => passwordInput.forceActiveFocus());
            }
        }
    }

    Timer {
        id: entryTimer
        interval: LockState.scaledDuration(80)
        repeat: false
        running: true
        onTriggered: root.entered = true
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Timer {
        id: idleTimer
        interval: 6000
        repeat: false
        onTriggered: {
            if (passwordInput.text.length === 0 && !root.controller.authenticating)
                root.awake = false;
        }
    }

    SequentialAnimation {
        id: shakeAnimation
        NumberAnimation { target: root; property: "shakeOffset"; to: -12; duration: 55 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 10; duration: 70 }
        NumberAnimation { target: root; property: "shakeOffset"; to: -7; duration: 65 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 4; duration: 60 }
        NumberAnimation { target: root; property: "shakeOffset"; to: 0; duration: 55 }
    }

    Component.onCompleted: Qt.callLater(() => passwordInput.forceActiveFocus())
}
