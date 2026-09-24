pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property bool lockActive: SettingsService.idleLockEnabled
        && SettingsService.idleLockMinutes > 0
    readonly property bool sleepActive: SettingsService.idleSleepEnabled
        && SettingsService.idleSleepMinutes > 0
    readonly property bool anyActive: lockActive || sleepActive

    property bool available: true
    property bool restartQueued: false
    property double lastSpawnTime: 0
    property int consecutiveFastExits: 0

    function buildCommand(): var {
        const args = ["swayidle", "-w"];
        if (lockActive) {
            args.push("timeout");
            args.push(String(SettingsService.idleLockMinutes * 60));
            args.push("qs ipc call lockscreen lock");
        }
        if (sleepActive) {
            args.push("timeout");
            args.push(String(SettingsService.idleSleepMinutes * 60));
            args.push("qs ipc call lockscreen lock; systemctl suspend");
        }
        return args;
    }

    function queueRestart(): void {
        if (!available)
            return;
        restartQueued = true;
        restartTimer.restart();
    }

    function applyRestart(): void {
        restartQueued = false;
        if (idler.running) {
            idler.running = false;
            return;
        }
        if (!anyActive)
            return;
        idler.command = buildCommand();
        lastSpawnTime = Date.now();
        idler.running = true;
    }

    Timer {
        id: restartTimer
        interval: 150
        repeat: false
        onTriggered: root.applyRestart()
    }

    Process {
        id: idler
        onExited: (exitCode, exitStatus) => {
            const fastExit = Date.now() - root.lastSpawnTime < 1000;
            if (fastExit) {
                root.consecutiveFastExits++;
                if (root.consecutiveFastExits >= 3) {
                    console.warn("IdleService: swayidle keeps exiting "
                        + "immediately; disabling. Ensure swayidle is "
                        + "installed and on PATH.");
                    root.available = false;
                    return;
                }
            } else {
                root.consecutiveFastExits = 0;
            }
            if (root.restartQueued || root.anyActive)
                Qt.callLater(() => root.applyRestart());
        }
    }

    Connections {
        target: SettingsService
        function onIdleLockEnabledChanged() { root.queueRestart(); }
        function onIdleLockMinutesChanged() { root.queueRestart(); }
        function onIdleSleepEnabledChanged() { root.queueRestart(); }
        function onIdleSleepMinutesChanged() { root.queueRestart(); }
    }

    Component.onCompleted: {
        if (anyActive)
            applyRestart();
    }
}
