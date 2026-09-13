pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../../services"

Singleton {
    id: root

    // `sessionLocked` is the actual ext-session-lock target. `phase` also
    // includes the visual pre/post transitions that happen outside it.
    property bool sessionLocked: false
    property string phase: "idle"
    property int lockSerial: 0
    property int unlockSerial: 0

    readonly property bool locked: sessionLocked || phase !== "idle"
    readonly property bool desktopTransitionVisible: phase === "locking"
        || phase === "unlocking"
        || phase === "revealHold"
        || phase === "revealing"
    readonly property real desktopWallpaperOpacity: phase === "locking"
        || phase === "unlocking"
        || phase === "revealHold" ? 1 : 0
    readonly property real desktopDimOpacity: phase === "locking" ? 0.48
        : (phase === "unlocking" || phase === "revealHold" ? 0.06 : 0)

    function scaledDuration(base: int): int {
        if (SettingsService.reduceMotion)
            return 1;
        return Math.max(1, Math.round(base
            / Math.max(0.1, SettingsService.globalAnimationSpeed)));
    }

    function lock(): void {
        if (locked)
            return;

        // First crossfade the live desktop into the current wallpaper and
        // darken it. The secure session lock is requested only after this
        // prelude has mostly completed.
        phase = "locking";
        lockCommitTimer.restart();
    }

    function markSecure(): void {
        if (!sessionLocked || phase !== "locking")
            return;

        phase = "locked";
        lockSerial++;
    }

    // Intentionally not exposed over IPC. Only successful PAM auth calls it.
    function unlockAuthorized(): void {
        if (!sessionLocked || phase === "unlocking"
                || phase === "revealHold" || phase === "revealing")
            return;

        // Lock-surface content fades away while the regular transition
        // surface is prepared behind it using the same wallpaper.
        phase = "unlocking";
        unlockSerial++;
        unlockReleaseTimer.restart();
    }

    Timer {
        id: lockCommitTimer
        interval: root.scaledDuration(300)
        repeat: false
        onTriggered: root.sessionLocked = true
    }

    Timer {
        id: unlockReleaseTimer
        interval: root.scaledDuration(320)
        repeat: false
        onTriggered: {
            root.sessionLocked = false;
            root.phase = "revealHold";
            revealHoldTimer.restart();
        }
    }

    Timer {
        id: revealHoldTimer
        interval: root.scaledDuration(45)
        repeat: false
        onTriggered: {
            root.phase = "revealing";
            revealFinishTimer.restart();
        }
    }

    Timer {
        id: revealFinishTimer
        interval: root.scaledDuration(360)
        repeat: false
        onTriggered: root.phase = "idle"
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            root.lock();
        }

        function getLocked(): bool {
            return root.locked;
        }
    }
}
