pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property int cpu_percent
    property string cpu_freq
    property int mem_percent
    property string mem_used
    property int gpu_percent
    property string gpu_used

    Process {
        id: process_cpu_percent
        running: true
        command: ["sh", "-c", "top -bn1 | rg '%Cpu' | awk '{print 100-$8}'"]
        stdout: SplitParser {
            onRead: data => root.cpu_percent = Math.round(data)
        }
    }

    Process {
        id: process_cpu_freq
        running: true
        command: ["sh", "-c", "lscpu --parse=MHZ"]
        stdout: StdioCollector {
            id: collector
            onStreamFinished: () => {
                const data = collector.text
                const mhz = data.split("\n").slice(4);
                const total = mhz.reduce((acc, e) => acc + Number(e), 0)
                const freq = total / mhz.length;

                root.cpu_freq = Math.round(freq) + " MHz";
            }
        }
    }

    Process {
        id: process_mem_percent
        running: true
        command: ["sh", "-c", "free | awk 'NR==2{print $3/$2*100}'"]
        stdout: SplitParser {
            onRead: data => root.mem_percent = Math.round(data)
        }
    }

    Process {
        id: process_mem_used
        running: true
        command: ["sh", "-c", "free --si -h | awk 'NR==2{v=$3; if(v ~ /[GMK]$/) v=v\"B\"; print v}'"]
        stdout: SplitParser {
            onRead: data => root.mem_used = data
        }
    }

    Process {
        id: process_gpu_percent
        running: true
        command: ["sh", "-c", "cat /sys/class/hwmon/hwmon*/device/gpu_busy_percent 2>/dev/null || echo 0"]
        stdout: SplitParser {
            onRead: data => root.gpu_percent = Math.round(Number(data))
        }
    }

    Process {
        id: process_gpu_used
        running: true
        command: ["sh", "-c", "awk '{pct=$2*100.0/$1; printf \"%.1fGB (%.1f%%)\\n\", $2/1073741824, pct}' <(paste /sys/class/drm/card1/device/mem_info_vram_total /sys/class/drm/card1/device/mem_info_vram_used)"]
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim();
                if (trimmed && trimmed !== '' && trimmed !== 'GB') {
                    root.gpu_used = trimmed;
                } else {
                    root.gpu_used = 'N/A';
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: () => {
            process_cpu_percent.running = true
            process_cpu_freq.running = true
            process_mem_percent.running = true
            process_mem_used.running = true
            process_gpu_percent.running = true
            process_gpu_used.running = true
        }
    }
}
