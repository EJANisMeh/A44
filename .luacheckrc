return {
  std = "lua52",
  globals = {
    -- Add more Roblox globals here as needed
    "game", "workspace", "script", "player", "Players", "require", "warn", "print", "task", "wait",
    "Instance", "Enum", "Vector3", "CFrame", "UDim2", "Color3",
  },
  ignore = {
    "211", -- Unused local variable
    "212", -- Unused argument
    "213", -- Unused loop variable
    "611", -- Line consists of nothing but whitespace
    "612", -- Line contains trailing whitespace
  },
  exclude_files = {
    "src/ReplicatedStorage/Modules/**",
  },
}