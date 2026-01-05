hidutil property --set '{"UserKeyMapping":[\
  {"HIDKeyboardModifierMappingSrc":0x70000002A,"HIDKeyboardModifierMappingDst":0x700000029},\
    {"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000002A}\
      ]}'

hidutil property --set '{"UserKeyMapping":[\
  {"HIDKeyboardModifierMappingSrc":0xC000000CD,"HIDKeyboardModifierMappingDst": 0x700000041}\
    ]}'

# pad to 4 bytes + remove leading 0s:
# 0x0007 -> 0x00000007
#     0x0041 ->     0x00000041
#                  0x700000041

#  ╻   To      ╻Sym╻      Fn (FnX)    ╻       Description       ╻
#  ╏───────────╏───╏┬─────────────────╏─────────────────────────╏
#  │                │  0x0007         │                         │
#  │  00ff0005  􀆫  │ F1  0x70000003a │ Screen Brightness Down  │ 🔅
#  │  00ff0004  􀆭  │ F2  0x70000003b │ Screen Brightness Up    │ 🔆
#  │  ff010010  􀇴  │ F3  0x70000003c │                         │
#  │  000c0221  􀊫  │ F4  0x70000003d │ Search                  │ 🔍
#  │  000c00cf  🎤︎  │ F5  0x70000003e │ Mic                     │ 🎤
#  │  0001009b  􀆹  │ F6  0x70000003f │ Toggle Do not disturb   │  
#  │  000c00b4  􀊉  │ F7  0x700000040 │ Skip Prev.              │ ⏪️
#  │  000c00cd  􀊇  │ F8  0x700000041 │ Play/Pause              │ ⏯️
#  │  000c00b3  􀊋  │ F9  0x700000042 │ Skip Next.              │ ⏩️
#  │  000c00e2  􀊠  │ F10 0x700000043 │ Mute                    │ 🔈🔇
#  │  000c00ea  􀊤  │ F11 0x700000044 │ Volume Down             │ 🔉
#  │  000c00e9  􀊨  │ F12 0x700000045 │ Volume Up               │ 🔊
#  ╹                ╹                 ╹                         ╹
# 0x ff01 0002         Dashboard
# 0x ff01 0010         Expose_All
# 0x ff01 0020  􀆫     Brightness_Up
# 0x ff01 0021  􀆭     Brightness_Down

# ioreg -l|grep FnFunctionUsageMap|grep -Eo 0x[0-9a-fA-F]+,0x[0-9a-fA-F]+ | pbcopy
# 0001: Generic Desktop
# 0007: Keyboard
# 000c: Consumer
# 00ff: kHIDUsage_AV_TopCase
# ff00: kHIDPage_AppleVendor
# ff01: kHIDPage_AppleVendorKeyboard
#  ╻     From (FnX)     ╻      To      ╻Sybl╻      Description        ╻
#  ╏─────┬──────────────╏──────────────╏────╏─────────────────────────╏
#  │  F1 │ 0x 0007 003a │ 0x 00ff 0005 │ 􀆫 │ Screen Brightness Down  │  🔅
#  │  F2 │ 0x 0007 003b │ 0x 00ff 0004 │ 􀆭 │ Screen Brightness Up    │  🔆
#  │  F3 │ 0x 0007 003c │ 0x ff01 0010 │ 􀇴 │                         │
#  │  F4 │ 0x 0007 003d │ 0x 000c 0221 │ 􀊫 │ Search                  │  🔍
#  │  F5 │ 0x 0007 003e │ 0x 000c 00cf │ 🎤︎ │ Mic                     │  🎤
#  │  F6 │ 0x 0007 003f │ 0x 0001 009b │ 􀆹 │ Toggle Do not disturb   │  
#  │  F7 │ 0x 0007 0040 │ 0x 000c 00b4 │ 􀊉 │ Skip Prev.              │ ⏪️
#  │  F8 │ 0x 0007 0041 │ 0x 000c 00cd │ 􀊇 │ Play/Pause              │ ⏯️
#  │  F9 │ 0x 0007 0042 │ 0x 000c 00b3 │ 􀊋 │ Skip Next.              │ ⏩️
#  │ F10 │ 0x 0007 0043 │ 0x 000c 00e2 │ 􀊠 │ Mute                    │ 🔈🔇
#  │ F11 │ 0x 0007 0044 │ 0x 000c 00ea │ 􀊤 │ Volume Down             │ 🔉
#  │ F12 │ 0x 0007 0045 │ 0x 000c 00e9 │ 􀊨 │ Volume Up               │ 🔊
#  ╹     ╹              ╹              ╹    ╹                         ╹
#                         0x ff01 0002         Dashboard
#                         0x ff01 0010         Expose_All
#                         0x ff01 0020  􀆫     Brightness_Up
#                         0x ff01 0021  􀆭     Brightness_Down


# FF00-FFFF Vendor-defined


#    0x 00ff -- kHIDUsage_AV_TopCase_
#  ╻              ╻                     ╻                                                   ╻
#  │ 0x 00ff 0003 │ KeyboardFn          │ kHIDUsage_AV_TopCase_KeyboardFn                   │
#  │ 0x 00ff 0004 │ BrightnessUp        │ kHIDUsage_AV_TopCase_BrightnessUp                 │
#  │ 0x 00ff 0004 │ BrightnessDown      │ kHIDUsage_AV_TopCase_BrightnessDown               │
#  │ 0x 00ff 0005 │ VideoMirror         │ kHIDUsage_AV_TopCase_VideoMirror                  │
#  │ 0x 00ff 0006 │ IlluminationToggle  │ kHIDUsage_AV_TopCase_IlluminationToggle           │
#  │ 0x 00ff 0007 │ IlluminationUp      │ kHIDUsage_AV_TopCase_IlluminationUp               │
#  │ 0x 00ff 0008 │ IlluminationDown    │ kHIDUsage_AV_TopCase_IlluminationDown             │
#  │ 0x 00ff 0009 │ ClamshellLatched    │ kHIDUsage_AV_TopCase_ClamshellLatched             │
#  │ 0x 00ff 000A │ DeviceManagement    │ kHIDUsage_AV_TopCase_DeviceManagement             │
#  │ 0x 00ff 00C0 │ Keyboard            │ kHIDUsage_AV_TopCase_Keyboard                     │
#  │ 0x 00ff 00ff │ Trackpad            │ kHIDUsage_AV_TopCase_Trackpad                     │
#  │ 0x 00ff 00ff │ Reserved            │ kHIDUsage_AV_TopCase_Reserved                     │
#  │ 0x 00ff 00ff │ Reserved_MouseData  │ kHIDUsage_AV_TopCase_Reserved_MouseData           │
#  ╹              ╹                     ╹                                                   ╹

#    0x ff01 --  AppleVendor Keyboard Page
#  ╻              ╻                     ╻                                                   ╻
#  │ 0x ff01 0001 │ Spotlight           │ kHIDUsage_AppleVendorKeyboard_Spotlight           │
#  │ 0x ff01 0002 │ Dashboard           │ kHIDUsage_AppleVendorKeyboard_Dashboard           │
#  │ 0x ff01 0003 │ Function            │ kHIDUsage_AppleVendorKeyboard_Function            │
#  │ 0x ff01 0004 │ Launchpad           │ kHIDUsage_AppleVendorKeyboard_Launchpad           │
#  │ 0x ff01 000a │ Reserved            │ kHIDUsage_AppleVendorKeyboard_Reserved            │
#  │ 0x ff01 000b │ CapsLockDelayEnable │ kHIDUsage_AppleVendorKeyboard_CapsLockDelayEnable │
#  │ 0x ff01 000c │ PowerState          │ kHIDUsage_AppleVendorKeyboard_PowerState          │
#  │ 0x ff01 0010 │ Expose_All          │ kHIDUsage_AppleVendorKeyboard_Expose_All          │
#  │ 0x ff01 0011 │ Expose_Desktop      │ kHIDUsage_AppleVendorKeyboard_Expose_Desktop      │
#  │ 0x ff01 0020 │ Brightness_Up       │ kHIDUsage_AppleVendorKeyboard_Brightness_Up       │
#  │ 0x ff01 0021 │ Brightness_Down     │ kHIDUsage_AppleVendorKeyboard_Brightness_Down     │
#  │ 0x ff01 0030 │ Language            │ kHIDUsage_AppleVendorKeyboard_Language            │
#  ╹              ╹                     ╹                                                   ╹

{
  "source": "https://www.freebsddiary.org/APC/usb_hid_usages.php",
  "0x0007": {
    "name": "Keyboard",
    "0x0000": "Reserved (no event indicated)",
    "0x0001": "Keyboard ErrorRollOver",
    "0x0002": "Keyboard POSTFail",
    "0x0003": "Keyboard ErrorUndefined",
    "0x0004": "Keyboard a and A",
    "0x0005": "Keyboard b and B",
    "0x0006": "Keyboard c and C",
    "0x0007": "Keyboard d and D",
    "0x0008": "Keyboard e and E",
    "0x0009": "Keyboard f and F",
    "0x000A": "Keyboard g and G",
    "0x000B": "Keyboard h and H",
    "0x000C": "Keyboard i and I",
    "0x000D": "Keyboard j and J",
    "0x000E": "Keyboard k and K",
    "0x000F": "Keyboard l and L",
    "0x0010": "Keyboard m and M",
    "0x0011": "Keyboard n and N",
    "0x0012": "Keyboard o and O",
    "0x0013": "Keyboard p and P",
    "0x0014": "Keyboard q and Q",
    "0x0015": "Keyboard r and R",
    "0x0016": "Keyboard s and S",
    "0x0017": "Keyboard t and T",
    "0x0018": "Keyboard u and U",
    "0x0019": "Keyboard v and V",
    "0x001A": "Keyboard w and W",
    "0x001B": "Keyboard x and X",
    "0x001C": "Keyboard y and Y",
    "0x001D": "Keyboard z and Z",
    "0x001E": "Keyboard 1 and !",
    "0x001F": "Keyboard 2 and @",
    "0x0020": "Keyboard 3 and #",
    "0x0021": "Keyboard 4 and $",
    "0x0022": "Keyboard 5 and %",
    "0x0023": "Keyboard 6 and ^",
    "0x0024": "Keyboard 7 and &",
    "0x0025": "Keyboard 8 and *",
    "0x0026": "Keyboard 9 and (",
    "0x0027": "Keyboard 0 and )",
    "0x0028": "Keyboard Return (ENTER)",
    "0x0029": "Keyboard ESCAPE",
    "0x002A": "Keyboard DELETE (Backspace)",
    "0x002B": "Keyboard Tab",
    "0x002C": "Keyboard Spacebar",
    "0x002D": "Keyboard - and (underscore)",
    "0x002E": "Keyboard = and +",
    "0x002F": "Keyboard [ and {",
    "0x0030": "Keyboard ] and }",
    "0x0031": "Keyboard \ and |",
    "0x0032": "Keyboard Non-US # and ~",
    "0x0033": "Keyboard ; and :",
    "0x0034": "Keyboard ' and "",
    "0x0035": "Keyboard Grave Accent and Tilde",
    "0x0036": "Keyboard, and <",
    "0x0037": "Keyboard . and >",
    "0x0038": "Keyboard / and ?",
    "0x0039": "Keyboard Caps Lock",
    "0x003A": "Keyboard F1",
    "0x003B": "Keyboard F2",
    "0x003C": "Keyboard F3",
    "0x003D": "Keyboard F4",
    "0x003E": "Keyboard F5",
    "0x003F": "Keyboard F6",
    "0x0040": "Keyboard F7",
    "0x0041": "Keyboard F8",
    "0x0042": "Keyboard F9",
    "0x0043": "Keyboard F10",
    "0x0044": "Keyboard F11",
    "0x0045": "Keyboard F12",
    "0x0046": "Keyboard PrintScreen",
    "0x0047": "Keyboard Scroll Lock",
    "0x0048": "Keyboard Pause",
    "0x0049": "Keyboard Insert",
    "0x004A": "Keyboard Home",
    "0x004B": "Keyboard PageUp",
    "0x004C": "Keyboard Delete Forward",
    "0x004D": "Keyboard End",
    "0x004E": "Keyboard PageDown",
    "0x004F": "Keyboard RightArrow",
    "0x0050": "Keyboard LeftArrow",
    "0x0051": "Keyboard DownArrow",
    "0x0052": "Keyboard UpArrow",
    "0x0053": "Keypad Num Lock and Clear",
    "0x0054": "Keypad /",
    "0x0055": "Keypad *",
    "0x0056": "Keypad -",
    "0x0057": "Keypad +",
    "0x0058": "Keypad ENTER",
    "0x0059": "Keypad 1 and End",
    "0x005A": "Keypad 2 and Down Arrow",
    "0x005B": "Keypad 3 and PageDn",
    "0x005C": "Keypad 4 and Left Arrow",
    "0x005D": "Keypad 5",
    "0x005E": "Keypad 6 and Right Arrow",
    "0x005F": "Keypad 7 and Home",
    "0x0060": "Keypad 8 and Up Arrow",
    "0x0061": "Keypad 9 and PageUp",
    "0x0062": "Keypad 0 and Insert",
    "0x0063": "Keypad . and Delete",
    "0x0064": "Keyboard Non-US \ and |",
    "0x0065": "Keyboard Application",
    "0x0066": "Keyboard Power",
    "0x0067": "Keypad =",
    "0x0068": "Keyboard F13",
    "0x0069": "Keyboard F14",
    "0x006A": "Keyboard F15",
    "0x006B": "Keyboard F16",
    "0x006C": "Keyboard F17",
    "0x006D": "Keyboard F18",
    "0x006E": "Keyboard F19",
    "0x006F": "Keyboard F20",
    "0x0070": "Keyboard F21",
    "0x0071": "Keyboard F22",
    "0x0072": "Keyboard F23",
    "0x0073": "Keyboard F24",
    "0x0074": "Keyboard Execute",
    "0x0075": "Keyboard Help",
    "0x0076": "Keyboard Menu",
    "0x0077": "Keyboard Select",
    "0x0078": "Keyboard Stop",
    "0x0079": "Keyboard Again",
    "0x007A": "Keyboard Undo",
    "0x007B": "Keyboard Cut",
    "0x007C": "Keyboard Copy",
    "0x007D": "Keyboard Paste",
    "0x007E": "Keyboard Find",
    "0x007F": "Keyboard Mute",
    "0x0080": "Keyboard Volume Up",
    "0x0081": "Keyboard Volume Down",
    "0x0082": "Keyboard Locking Caps Lock",
    "0x0083": "Keyboard Locking Num Lock",
    "0x0084": "Keyboard Locking Scroll Lock",
    "0x0085": "Keypad Comma",
    "0x0086": "Keypad Equal Sign",
    "0x0087": "Keyboard International1",
    "0x0088": "Keyboard International2",
    "0x0089": "Keyboard International3",
    "0x008A": "Keyboard International4",
    "0x008B": "Keyboard International5",
    "0x008C": "Keyboard International6",
    "0x008D": "Keyboard International7",
    "0x008E": "Keyboard International8",
    "0x008F": "Keyboard International9",
    "0x0090": "Keyboard LANG1",
    "0x0091": "Keyboard LANG2",
    "0x0092": "Keyboard LANG3",
    "0x0093": "Keyboard LANG4",
    "0x0094": "Keyboard LANG5",
    "0x0095": "Keyboard LANG6",
    "0x0096": "Keyboard LANG7",
    "0x0097": "Keyboard LANG8",
    "0x0098": "Keyboard LANG9",
    "0x0099": "Keyboard Alternate Erase",
    "0x009A": "Keyboard SysReq/Attention",
    "0x009B": "Keyboard Cancel",
    "0x009C": "Keyboard Clear",
    "0x009D": "Keyboard Prior",
    "0x009E": "Keyboard Return",
    "0x009F": "Keyboard Separator",
    "0x00A0": "Keyboard Out",
    "0x00A1": "Keyboard Oper",
    "0x00A2": "Keyboard Clear/Again",
    "0x00A3": "Keyboard CrSel/Props",
    "0x00A4": "Keyboard ExSel",
    "0x00E0": "Keyboard LeftControl",
    "0x00E1": "Keyboard LeftShift",
    "0x00E2": "Keyboard LeftAlt",
    "0x00E3": "Keyboard Left GUI",
    "0x00E4": "Keyboard RightControl",
    "0x00E5": "Keyboard RightShift",
    "0x00E6": "Keyboard RightAlt",
    "0x00E7": "Keyboard Right GUI",
  },
  "0x000c": {
    "name": "Consumer",
    "0x0000": "Unassigned",
    "0x0001": "Consumer Control",
    "0x0002": "Numeric Key Pad",
    "0x0003": "Programmable Buttons",
    "0x0020": "+10",
    "0x0021": "+100",
    "0x0022": "AM/PM",
    "0x0030": "Power",
    "0x0031": "Reset",
    "0x0032": "Sleep",
    "0x0033": "Sleep After",
    "0x0034": "Sleep Mode",
    "0x0035": "Illumination",
    "0x0036": "Function Buttons",
    "0x0040": "Menu",
    "0x0041": "Menu  Pick",
    "0x0042": "Menu Up",
    "0x0043": "Menu Down",
    "0x0044": "Menu Left",
    "0x0045": "Menu Right",
    "0x0046": "Menu Escape",
    "0x0047": "Menu Value Increase",
    "0x0048": "Menu Value Decrease",
    "0x0060": "Data On Screen",
    "0x0061": "Closed Caption",
    "0x0062": "Closed Caption Select",
    "0x0063": "VCR/TV",
    "0x0064": "Broadcast Mode",
    "0x0065": "Snapshot",
    "0x0066": "Still",
    "0x0080": "Selection",
    "0x0081": "Assign Selection",
    "0x0082": "Mode Step",
    "0x0083": "Recall Last",
    "0x0084": "Enter Channel",
    "0x0085": "Order Movie",
    "0x0086": "Channel",
    "0x0087": "Media Selection",
    "0x0088": "Media Select Computer",
    "0x0089": "Media Select TV",
    "0x008A": "Media Select WWW",
    "0x008B": "Media Select DVD",
    "0x008C": "Media Select Telephone",
    "0x008D": "Media Select Program Guide",
    "0x008E": "Media Select Video Phone",
    "0x008F": "Media Select Games",
    "0x0090": "Media Select Messages",
    "0x0091": "Media Select CD",
    "0x0092": "Media Select VCR",
    "0x0093": "Media Select Tuner",
    "0x0094": "Quit",
    "0x0095": "Help",
    "0x0096": "Media Select Tape",
    "0x0097": "Media Select Cable",
    "0x0098": "Media Select Satellite",
    "0x0099": "Media Select Security",
    "0x009A": "Media Select Home",
    "0x009B": "Media Select Call",
    "0x009C": "Channel Increment",
    "0x009D": "Channel Decrement",
    "0x009E": "Media Select SAP",
    "0x00A0": "VCR Plus",
    "0x00A1": "Once",
    "0x00A2": "Daily",
    "0x00A3": "Weekly",
    "0x00A4": "Monthly",
    "0x00B0": "Play",
    "0x00B1": "Pause",
    "0x00B2": "Record",
    "0x00B3": "Fast Forward",
    "0x00B4": "Rewind",
    "0x00B5": "Scan Next Track",
    "0x00B6": "Scan Previous Track",
    "0x00B7": "Stop",
    "0x00B8": "Eject",
    "0x00B9": "Random Play",
    "0x00BA": "Select DisC",
    "0x00BB": "Enter Disc",
    "0x00BC": "Repeat",
    "0x00BD": "Tracking",
    "0x00BE": "Track Normal",
    "0x00BF": "Slow Tracking",
    "0x00C0": "Frame Forward",
    "0x00C1": "Frame Back",
    "0x00C2": "Mark",
    "0x00C3": "Clear Mark",
    "0x00C4": "Repeat From Mark",
    "0x00C5": "Return To Mark",
    "0x00C6": "Search Mark Forward",
    "0x00C7": "Search Mark Backwards",
    "0x00C8": "Counter Reset",
    "0x00C9": "Show Counter",
    "0x00CA": "Tracking Increment",
    "0x00CB": "Tracking Decrement",
    "0x00E0": "Volume",
    "0x00E1": "Balance",
    "0x00E2": "Mute",
    "0x00E3": "Bass",
    "0x00E4": "Treble",
    "0x00E5": "Bass Boost",
    "0x00E6": "Surround Mode",
    "0x00E7": "Loudness",
    "0x00E8": "MPX",
    "0x00E9": "Volume Up",
    "0x00EA": "Volume Down",
    "0x00F0": "Speed Select",
    "0x00F1": "Playback Speed",
    "0x00F2": "Standard Play",
    "0x00F3": "Long Play",
    "0x00F4": "Extended Play",
    "0x00F5": "Slow",
    "0x0100": "Fan Enable",
    "0x0101": "Fan Speed",
    "0x0102": "Light",
    "0x0103": "Light Illumination Level",
    "0x0104": "Climate Control Enable",
    "0x0105": "Room Temperature",
    "0x0106": "Security Enable",
    "0x0107": "Fire Alarm",
    "0x0108": "Police Alarm",
    "0x0150": "Balance Right",
    "0x0151": "Balance Left",
    "0x0152": "Bass Increment",
    "0x0153": "Bass Decrement",
    "0x0154": "Treble Increment",
    "0x0155": "Treble Decrement",
    "0x0160": "Speaker System",
    "0x0161": "Channel Left",
    "0x0162": "Channel Right",
    "0x0163": "Channel Center",
    "0x0164": "Channel Front",
    "0x0165": "Channel Center Front",
    "0x0166": "Channel Side",
    "0x0167": "Channel Surround",
    "0x0168": "Channel Low Frequency Enhancement",
    "0x0169": "Channel Top",
    "0x016A": "Channel Unknown",
    "0x0170": "Sub-channel",
    "0x0171": "Sub-channel Increment",
    "0x0172": "Sub-channel Decrement",
    "0x0173": "Alternate Audio Increment",
    "0x0174": "Alternate Audio Decrement",
    "0x0180": "Application Launch Buttons",
    "0x0181": "AL Launch Button Configuration Tool",
    "0x0182": "AL Programmable Button Configuration",
    "0x0183": "AL Consumer Control Configuration",
    "0x0184": "AL Word Processor",
    "0x0185": "AL Text Editor",
    "0x0186": "AL Spreadsheet",
    "0x0187": "AL Graphics Editor",
    "0x0188": "AL Presentation App",
    "0x0189": "AL Database App",
    "0x018A": "AL Email Reader",
    "0x018B": "AL Newsreader",
    "0x018C": "AL Voicemail",
    "0x018D": "AL Contacts/Address Book",
    "0x018E": "AL Calendar/Schedule",
    "0x018F": "AL Task/Project Manager",
    "0x0190": "AL Log/Journal/Timecard",
    "0x0191": "AL Checkbook/Finance",
    "0x0192": "AL Calculator",
    "0x0193": "AL A/V Capture/Playback",
    "0x0194": "AL Local Machine Browser",
    "0x0195": "AL LAN/WAN Browser",
    "0x0196": "AL Internet Browser",
    "0x0197": "AL Remote Networking/ISP Connect",
    "0x0198": "AL Network Conference",
    "0x0199": "AL Network Chat",
    "0x019A": "AL Telephony/Dialer",
    "0x019B": "AL Logon",
    "0x019C": "AL Logoff",
    "0x019D": "AL Logon/Logoff",
    "0x019E": "AL Terminal Lock/Screensaver",
    "0x019F": "AL Control Panel",
    "0x01A0": "AL Command Line Processor/Run",
    "0x01A1": "AL Process/Task Manager",
    "0x01A2": "AL Select Tast/Application",
    "0x01A3": "AL Next Task/Application",
    "0x01A4": "AL Previous Task/Application",
    "0x01A5": "AL Preemptive Halt Task/Application",
    "0x0200": "Generic GUI Application Controls",
    "0x0201": "AC New",
    "0x0202": "AC Open",
    "0x0203": "AC Close",
    "0x0204": "AC Exit",
    "0x0205": "AC Maximize",
    "0x0206": "AC Minimize",
    "0x0207": "AC Save",
    "0x0208": "AC Print",
    "0x0209": "AC Properties",
    "0x021A": "AC Undo",
    "0x021B": "AC Copy",
    "0x021C": "AC Cut",
    "0x021D": "AC Paste",
    "0x021E": "AC Select All",
    "0x021F": "AC Find",
    "0x0220": "AC Find and Replace",
    "0x0221": "AC Search",
    "0x0222": "AC Go To",
    "0x0223": "AC Home",
    "0x0224": "AC Back",
    "0x0225": "AC Forward",
    "0x0226": "AC Stop",
    "0x0227": "AC Refresh",
    "0x0228": "AC Previous Link",
    "0x0229": "AC Next Link",
    "0x022A": "AC Bookmarks",
    "0x022B": "AC History",
    "0x022C": "AC Subscriptions",
    "0x022D": "AC Zoom In",
    "0x022E": "AC Zoom Out",
    "0x022F": "AC Zoom",
    "0x0230": "AC Full Screen View",
    "0x0231": "AC Normal View",
    "0x0232": "AC View Toggle",
    "0x0233": "AC Scroll Up",
    "0x0234": "AC Scroll Down",
    "0x0235": "AC Scroll",
    "0x0236": "AC Pan Left",
    "0x0237": "AC Pan Right",
    "0x0238": "AC Pan",
    "0x0239": "AC New Window",
    "0x023A": "AC Tile Horizontally",
    "0x023B": "AC Tile Vertically",
    "0x023C": "AC Format",
  }
}

