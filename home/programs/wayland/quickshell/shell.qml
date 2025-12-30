//@ pragma UseQApplication
import qs.bar
import qs.notifications
import qs.osd
import Quickshell

ShellRoot {
    settings.watchFiles: false;

    Bar {}
    NotificationOverlay {}
    OSD {}
}
