import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import QtQuick
import "../state"

WlSessionLock {
    id: root

    property string pendingPassword: ""
    property string authMessage: ""
    property bool authMessageIsError: false
    property bool authenticating: false
    property int failureSerial: 0

    locked: LockState.sessionLocked

    onSecureChanged: {
        if (secure)
            LockState.markSecure();
    }

    function authenticate(password: string): void {
        if (authenticating || password.length === 0)
            return;

        pendingPassword = password;
        authMessage = "Checking password…";
        authMessageIsError = false;
        authenticating = pamContext.start();

        if (!authenticating) {
            pendingPassword = "";
            authMessage = "Could not start authentication";
            authMessageIsError = true;
            failureSerial++;
        }
    }

    function finishAuthentication(result): void {
        authenticating = false;
        pendingPassword = "";

        if (result === PamResult.Success) {
            authMessage = "";
            authMessageIsError = false;
            LockState.unlockAuthorized();
            return;
        }

        authMessage = result === PamResult.MaxTries
            ? "Too many attempts"
            : result === PamResult.Error
                ? "Authentication error"
                : "That password didn't work";
        authMessageIsError = true;
        failureSerial++;
    }

    onLockedChanged: {
        if (locked) {
            pendingPassword = "";
            authMessage = "";
            authMessageIsError = false;
            authenticating = false;
        } else if (pamContext.active) {
            pamContext.abort();
        }
    }

    property PamContext pamContext: PamContext {
        configDirectory: "pam"
        config: "password.conf"
        user: Quickshell.env("USER") || ""

        onPamMessage: {
            if (responseRequired && root.pendingPassword !== "") {
                const response = root.pendingPassword;
                root.pendingPassword = "";
                respond(response);
            }

            if (messageIsError && message.length > 0) {
                root.authMessage = message;
                root.authMessageIsError = true;
            }
        }

        onCompleted: result => root.finishAuthentication(result)

        onError: error => {
            console.warn("Lockscreen PAM error:", PamError.toString(error));
        }
    }

    surface: Component {
        LockScreenSurface {
            controller: root
        }
    }
}
