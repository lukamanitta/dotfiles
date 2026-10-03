import QtQuick
import Quickshell.Services.Pam

/**
 * Thin PAM wrapper for the lock. One context, one pending password; a submit
 * starts the conversation and responds to the first prompt with it. Emits
 * `succeeded`/`failed` so the surface can shake, clear and collapse.
 */
Item {
    id: auth

    property string user: ""
    readonly property bool authenticating: pam.active

    signal failed
    signal succeeded

    property string pendingPassword: ""
    property string lastError: ""

    function submit(password) {
        if (pam.active)
            return;
        auth.lastError = "";
        auth.pendingPassword = password;
        pam.start();
    }

    PamContext {
        id: pam
        config: "login"
        user: auth.user

        onResponseRequiredChanged: {
            if (responseRequired)
                respond(auth.pendingPassword);
        }

        onPamMessage: {
            if (messageIsError && message.length > 0)
                auth.lastError = message;
        }

        onCompleted: result => {
            auth.pendingPassword = "";
            if (result === PamResult.Success)
                auth.succeeded();
            else
                auth.failed();
        }

        onError: {
            auth.pendingPassword = "";
            auth.failed();
        }
    }
}
