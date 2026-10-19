-- Semana atual: define Day1..Day7 (numero do dia), Dow1..Dow7 (0=dom .. 6=sab) e TodayCol.
-- WeekStart=1 comeca na segunda.

function Initialize()
	last = ''
end

function Update()
	local t = os.date('*t')
	local monday = tonumber(SKIN:GetVariable('WeekStart')) == 1
	local key = t.year .. t.yday .. tostring(monday)
	if key == last then return 0 end
	last = key
	local dow = t.wday - 1 -- 0 = domingo
	local offset = monday and (dow + 6) % 7 or dow
	local base = os.time { year = t.year, month = t.month, day = t.day - offset, hour = 12 }
	for i = 1, 7 do
		local d = os.date('*t', base + (i - 1) * 86400)
		SKIN:Bang('!SetVariable', 'Day' .. i, d.day)
		SKIN:Bang('!SetVariable', 'Dow' .. i, d.wday - 1)
	end
	SKIN:Bang('!SetVariable', 'TodayCol', offset)
	-- o dia de hoje fica na cor do papel, sobre a tira dobrada
	local paper, ink, dim = SKIN:GetVariable('Paper'), SKIN:GetVariable('Text'), SKIN:GetVariable('TextDim')
	for i = 1, 7 do
		local today = (i - 1) == offset
		SKIN:Bang('!SetOption', 'MeterN' .. i, 'FontColor', today and paper or dim)
		SKIN:Bang('!SetOption', 'MeterD' .. i, 'FontColor', today and paper or ink)
	end
	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')
	return 0
end
