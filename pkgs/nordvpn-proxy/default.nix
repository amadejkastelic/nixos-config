{
  buildFirefoxXpiAddon,
  lib,
}:

buildFirefoxXpiAddon {
  pname = "nordvpn-proxy";
  version = "5.6.5";
  addonId = "nordvpnproxy@nordvpn.com";
  url = "https://addons.mozilla.org/firefox/downloads/file/4896617/nordvpn_proxy_extension-5.6.5.xpi";
  sha256 = "fca88190c4648708739a22b2db0a24ea95b1cfb5e9f3e1e5a2cfb69208e72c06";
  mozPermissions = [
    "alarms"
    "scripting"
    "proxy"
    "webRequest"
    "webNavigation"
    "privacy"
    "storage"
    "notifications"
    "tabs"
    "contextMenus"
    "activeTab"
    "unlimitedStorage"
    "downloads"
    "declarativeNetRequestWithHostAccess"
    "webRequestBlocking"
    "dns"
    "<all_urls>"
    "https://youtube.com/*"
    "https://www.youtube.com/*"
    "https://tv.youtube.com/*"
  ];
  meta = {
    homepage = "https://addons.mozilla.org/en-US/firefox/addon/nordvpn-proxy-extension/";
    description = "NordVPN - a VPN proxy extension for Firefox";
    platforms = lib.platforms.all;
  };
}
