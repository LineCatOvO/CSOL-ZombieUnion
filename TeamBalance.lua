function TeamBalance(player)
	ct=0;
	tr=0;
	for i=1,32 do
		local player=Game.Player:Create(i)
		if player~=nil then
			if player.Team==Game.TEAM.CT then
				ct=ct+1;
			else
				tr=tr+1;
			end
		end
	end
	if ct-tr>1 then
		if player.Team==Game.TEAM.CT then
			player.Team=Game.TEAM.TR;
		end
	elseif ct-tr<-1 then
		if player.Team==Game.TEAM.TR then
			player.Team=Game.TEAM.CT;
		end
	end
end