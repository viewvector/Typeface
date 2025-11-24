local Library = {}

-- // Assert Alternative
Library.Throw = function(Condition, String)
    return Condition or error(String)
end

--[[ Compatibility Check ]] do
    cloneref = cloneref or function(service) return service end

    isfile = Library.Throw(isfile, 'Executor is incompatible!')
    isfolder = Library.Throw(isfolder, 'Executor is incompatible!')
    writefile = Library.Throw(writefile, 'Executor is incompatible!')
    makefolder = Library.Throw(makefolder, 'Executor is incompatible!')
    getcustomasset = Library.Throw(getcustomasset, 'Executor is incompatible!')
end

-- // Metamethods
Library.__index = Library

-- // Services
local Http = cloneref(game:GetService("HttpService"))

-- // Tables
Library.Fonts = {}

-- // Functions
function Library:Register(Info)
    Info = setmetatable(Info or {}, Library)

    Info.Url = Library.Throw(Info.Url, 'Url is missing!')
    Info.Name = Library.Throw(Info.Name or self.Name, 'Name is missing!')

    Info.Weight = Info.Weight or 'Regular'
    Info.Style = Info.Style or 'Normal'

    Info.Path = Library.Throw(Info.Path or Library.Path, 'Path is missing!')
    Info.EnumWeight = Library.Throw(Enum.FontWeight[Info.Weight], `Couldn't find enum weight for "{Info.Weight}"!`)
    Info.NumWeight = Library.Throw(Info.EnumWeight.Value, `Couldn't find numerical weight for "{Info.Weight}"!`)
    Info.EnumStyle = Library.Throw(Enum.FontStyle[Info.Style], `Couldn't find enum style for "{Info.Style}"!`)

    Info.FullName = `{ Info.NumWeight ~= '400' and '-' .. Info.Weight or '' }{ Info.Style ~= 'Normal' and '-' .. Info.Style or '' }`
    Info.FontPath = `{ Info.Path }\\{ Info.Name }{ Info.FullName }.ttf`
    Info.FamilyPath = `{ Info.Path }\\Families`
    Info.JsonPath = `{ Info.FamilyPath }\\{ Info.Name }.json`

    Info.Family = self.Family

    Library:CheckPath(Info.Path)
    Library:CheckPath(Info.FamilyPath)

    Info:CreateFont()
    Info:CreateFamily()

    Library.Fonts[Info.Name .. Info.FullName] = Info
    Library.Path = Info.Path

    return Info:Get(), Info
end

function Library:Get(Name)
    local Face = Library.Fonts[Name] or self
    return Font.new(getcustomasset(Face.JsonPath), Face.EnumWeight, Face.EnumStyle)
end

function Library:CheckPath(Path)
    if isfolder(Path) then return end
    makefolder(Path)
end

function Library:CreateFont()
    local Info = Library.Throw(self, 'Information is missing!')

    if isfile(Info.FontPath) then return end

    local Success, Result = pcall(function()
        return game:HttpGet(Info.Url)
    end)

    Library.Throw(Success, `Failed to fetch "{Info.Name}-{Info.Weight}-{Info.Style}" file!`)
    warn(`Successfully fetched "{Info.Name}-{Info.Weight}-{Info.Style}" file!`)

    writefile(Info.FontPath, Result)
end

function Library:CreateFamily()
    local Info = Library.Throw(self, 'Information is missing!')

    Info.Family = Info.Family or {
        name = Info.Name,
        faces = {}
    }

    Info.FullName = string.split(Info.FullName, '-')
    Info.FullName = `{ Info.FullName[2] }{ Info.FullName[3] and ' ' .. Info.FullName[3] or '' }`

    table.insert(Info.Family.faces, {
        name = Info.FullName,
        weight = Info.NumWeight,
        style = string.lower(Info.Style),
        assetId = getcustomasset(Info.FontPath),
    })

    writefile(Info.JsonPath, Http:JSONEncode(Info.Family))
end

return Library
