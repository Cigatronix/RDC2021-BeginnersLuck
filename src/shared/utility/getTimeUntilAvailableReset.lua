local lastReset = 0
local function getTimeUntilAvailableReset()
	local now = time()
	if now - lastReset < 1 then
		return 1 - (now - lastReset)
	end
	lastReset = now

	return 0
end

return {
	getTimeUntilAvailableReset = getTimeUntilAvailableReset,
}
