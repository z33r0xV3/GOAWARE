local vape = shared.vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local function runChunk(source, name)
	local chunk = loadstring(source, name)
	if chunk then chunk() end
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function goawareHttpGet(url, nocache, attempt)
	local adapter = shared.GoAwareDevHttpGet
	if type(adapter) == 'function' then
		return adapter(url, nocache, attempt)
	end
	return game:HttpGet(url, nocache)
end
local function downloadFile(path, func)
	local devLoader = shared.GoAwareDevLoadSource
	if type(devLoader) == 'function' then
		local body = devLoader(path)
		return func and func(path) or body
	end
	if not isfile(path) then
		local suc, res = pcall(function()
			return goawareHttpGet('https://raw.githubusercontent.com/z33r0xV3/GOAWARE/main/'..select(1, path:gsub('goaware/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

vape.Place = 5938036553
if isfile('goaware/games/'..vape.Place..'.lua') then
	runChunk(readfile('goaware/games/'..vape.Place..'.lua'), 'bedwars')
else
	if not shared.GoAwareDeveloper then
		local suc, res = pcall(function()
			return goawareHttpGet('https://raw.githubusercontent.com/z33r0xV3/GOAWARE/main/games/'..vape.Place..'.lua', true)
		end)
		if suc and res ~= '404: Not Found' then
			runChunk(downloadFile('goaware/games/'..vape.Place..'.lua'), 'bedwars')
		end
	end
end
