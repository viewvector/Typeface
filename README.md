# Example
Roblox Custom Typeface Registration

```lua
local Typeface = loadstring(game:HttpGet("https://github.com/ubt5/Typeface/raw/refs/heads/main/Register.lua"))()

local Font, Face = Typeface:Register{
    Url = "https://github.com/ubt5/Typeface/raw/refs/heads/main/Fonts/Verdana.ttf", -- Use a direct (raw) .ttf file URL
    Name = "Verdana",
    Weight = "Regular",
    Style = "Normal",
    Path = "Fonts",
}

local BoldFont = Face:Register{
    Url = "https://github.com/ubt5/Typeface/raw/refs/heads/main/Fonts/VerdanaBold.ttf",
    Weight = "Bold",
}

local TextInstance = Instance.new("TextLabel")
TextInstance.FontFace = BoldFont -- Alternatively: BoldFont:Get() or Typeface:Get("Verdana-Bold")
```
