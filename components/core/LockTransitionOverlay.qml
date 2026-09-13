import Quickshell
import Quickshell.Wayland
import QtQuick
import "../state"
import "../theme"
import "../../services"

// A normal layershell surface used only before the compositor session-locks
// and just after it unlocks. It crossfades the desktop into/out of the current
// wallpaper so application windows do not pop abruptly.
PanelWindow {
    id: root

    required property var modelData
    readonly property var targetScreen: modelData
    readonly property string wallpaperSource: {
        const outputName = targetScreen ? targetScreen.name : "";
        const displayed = outputName !== ""
            ? DisplayedWallpaperState.sourceForScreen(outputName) : "";
        return displayed !== "" ? displayed : WallpaperService.source.toString();
    }
    readonly property int fadeDuration: LockState.scaledDuration(300)

    screen: targetScreen
    visible: LockState.desktopTransitionVisible
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "lock-transition"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    Rectangle {
        anchors.fill: parent
        color: Theme.wallpaperFallbackColor
        opacity: wallpaper.status === Image.Ready
            ? 0 : LockState.desktopWallpaperOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: root.fadeDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        source: root.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
        cache: true
        opacity: LockState.desktopWallpaperOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: root.fadeDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: LockState.desktopDimOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: root.fadeDuration
                easing.type: Easing.OutCubic
            }
        }
    }
}
