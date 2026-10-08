# UpdateDialog

Pass `UpdateDialog` to `WindUI:CreateWindow`. When enabled, the popup appears
before the Hub window is created. The Hub opens after the user presses its
button.

```lua
local Window = WindUI:CreateWindow({
    Title = "Peakx Hub",
    Icon = "rbxassetid://YOUR_LOGO_ID",
    DataSave = true,

    UpdateDialog = {
        Enabled = true,
        Version = "v1.5.1",
        Title = "Peakx Updater!",
        Icon = "rbxassetid://YOUR_LOGO_ID", -- Optional; falls back to the Hub icon
        Description = table.concat({
            "• Added Auto Rebirth system",
            "• Fixed Ghost Mode crashes on Xeno/Solara",
            "• Optimized UI rendering speed",
        }, "\n"),
        ButtonText = "Let's Farm!", -- Defaults to "Thanks!"
    },
})
```

Each description line is shown as a separate bullet. Long descriptions can be
scrolled inside a bounded description area without moving the button. The
version is displayed in a glass-style badge, and the popup uses an animated
entrance. Set `Enabled = false` to skip the popup.
