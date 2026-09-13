import QtQuick
import QtQuick.Dialogs
import ".."
import "../../../services"

Column {
    id: root
    width: parent ? parent.width : 0
    spacing: 12

    SettingsGroup {
        SettingsProfileRow {
            width: parent.width
            displayName: SettingsService.draftEffectiveDisplayName()
            accountName: SettingsService.systemUserName
            profileSource: SettingsService.draftProfilePictureSource()
            customPicture: SettingsService.draftValue("profilePicture") !== ""
            onChangeRequested: avatarDialog.open()
            onClearRequested: SettingsService.setDraftValue("profilePicture", "")
        }
    }

    SettingsGroup {
        SettingsTextRow {
            width: parent.width
            title: "Display name"
            detail: "Name shown on the lock screen; this does not change your system account"
            value: SettingsService.draftValue("userDisplayName")
            onValueRequested: value => SettingsService.setDraftValue("userDisplayName", value)
        }
    }

    FileDialog {
        id: avatarDialog
        title: "Choose profile picture"
        fileMode: FileDialog.OpenFile
        options: FileDialog.DontUseNativeDialog
        nameFilters: ["Images (*.png *.jpg *.jpeg *.webp)"]

        onAccepted: {
            SettingsService.setDraftValue("profilePicture", selectedFile.toString());
        }
    }
}
