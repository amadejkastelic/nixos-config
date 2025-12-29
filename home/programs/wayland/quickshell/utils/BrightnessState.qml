pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: persist.brightness

    PersistentProperties {
        id: persist
        reloadableId: "persistedBrightness"
        property string screenInterface: ""
        readonly property string path: screenInterface ? `/sys/class/backlight/${screenInterface}` : ""
        readonly property int rawBrightness: screenInterface ? Number(getRawBrightness.text()) : 0
        readonly property int max: screenInterface ? Number(getMaxBrightness.text()) : 1
        readonly property real brightness: max > 0 ? rawBrightness / max : 0
    }

    Process {
        id: getScreenInterface

        running: true
        command: ["sh", "-c", "ls -w1 /sys/class/backlight 2>/dev/null | head -1 || true"]
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim();
                if (trimmed) {
                    persist.screenInterface = trimmed;
                }
            }
        }
    }

    FileView {
        id: getMaxBrightness
        path: persist.path ? `${persist.path}/max_brightness` : ""
        blockLoading: true
    }

    FileView {
        id: getRawBrightness
        path: persist.path ? `${persist.path}/brightness` : ""
        blockLoading: true

        watchChanges: true
        onFileChanged: this.reload()
    }
}
