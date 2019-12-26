
BattleEventType = _G.BattleEventType

BGSoundPlayer = {
    next_player_time = 0
}

local SoundDurations = {}

SoundDurations[BattleEventType.FIRST_BLOOD] = {dir = "Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\1First Blood.mp3", duration = 1.9965}
SoundDurations[BattleEventType.MULTI_KILL] = {}
SoundDurations[BattleEventType.MULTI_KILL][3] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\2Killing Spree.mp3",duration=2.0925}
SoundDurations[BattleEventType.MULTI_KILL][4] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\3Dominating.mp3",duration=2.1885}
SoundDurations[BattleEventType.MULTI_KILL][5] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\4Mega Kill.mp3",duration=1.9245}
SoundDurations[BattleEventType.MULTI_KILL][6] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\5Unstoppable.mp3",duration=2.2125}
SoundDurations[BattleEventType.MULTI_KILL][7] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\6Wicked Sick.mp3",duration=1.5165}
SoundDurations[BattleEventType.MULTI_KILL][8] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\7MONSTER KILL.mp3",duration=2.3565}
SoundDurations[BattleEventType.MULTI_KILL][9] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\8Godlike.mp3",duration=1.8045}
SoundDurations[BattleEventType.MULTI_KILL][10] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\MultiKill\\9HOLY SHIT.mp3",duration=1.9245}
SoundDurations[BattleEventType.CONTINUE_KILL] = {}
SoundDurations[BattleEventType.CONTINUE_KILL][2] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\ContinuKill\\1Double Kill.mp3",duration=2.0925}
SoundDurations[BattleEventType.CONTINUE_KILL][3] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\ContinuKill\\2Triple Kill.mp3",duration=2.0205}
SoundDurations[BattleEventType.CONTINUE_KILL][4] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\ContinuKill\\3Ultra Kill.mp3",duration=1.8525}
SoundDurations[BattleEventType.CONTINUE_KILL][5] = {dir="Interface\\Addons\\BGHelper\\Sound\\Dota2\\Axe\\ContinuKill\\4Rampage.mp3",duration=2.0445}


local SoundPlayQueue = {}

function BGSoundPlayer:AddSoundToQueue(sound_type,value)

    if(sound_type == BattleEventType.FIRST_BLOOD) then
        table.insert(SoundPlayQueue,SoundDurations[BattleEventType.FIRST_BLOOD])
    elseif(sound_type == BattleEventType.MULTI_KILL) then
        if(value > 10)then value = 10 end
        table.insert(SoundPlayQueue,SoundDurations[sound_type][value])
    elseif(sound_type == BattleEventType.CONTINUE_KILL) then
        if(value > 5)then value = 5 end
        table.insert(SoundPlayQueue,SoundDurations[sound_type][value])
    end

end

function BGSoundPlayer:PlayNextSound()

    local current_time = GetTime()

    if( current_time < self.next_player_time)then
        return
    end

    if(BGSoundPlayer:SoundInQueue())then
        local x
        PlaySoundFile(SoundPlayQueue[1].dir, "Master")
		x = SoundPlayQueue[1].duration
		table.remove(SoundPlayQueue, 1)

		self.next_player_time = current_time + x
    else
		self.next_player_time = current_time + 0.3
    end

end

function BGSoundPlayer:SoundInQueue()
	if table.getn(SoundPlayQueue) > 0 then
		return 1
	else
		return nil
	end
end