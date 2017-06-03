function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game)
	TargetPlayerBtn = nil;
	Game = game;
	setMaxSize(450, 350);
	vert = UI.CreateVerticalLayoutGroup(rootParent);
	if (game.Us == nil) then
		UI.CreateLabel(vert).SetText("You cannot use the Diplomacy game, cause you aren't in the game");
		return;
	end
  	local horz = UI.CreateHorizontalLayoutGroup(vert);
 	moneyobj = UI.CreateLabel(horz).SetText('Current Money: ' .. Mod.PlayerGameData.Money);
	OpenMenu();
end
function OpenMenu()
	DeleteUI();
	local horz = UI.CreateHorizontalLayoutGroup(vert);
	--UI.CreateLabel(horz).SetText("Shop");
	openshopbutton = UI.CreateButton(horz).SetText("Shop").SetOnClick(Openshop);
 	local horz = UI.CreateHorizontalLayoutGroup(vert);
 	--UI.CreateLabel(horz).SetText("Declare War");
	declarewarbutton = UI.CreateButton(horz).SetText("Declare War").SetOnClick(OpenDeclarWar);
 	local horz = UI.CreateHorizontalLayoutGroup(vert);
	--UI.CreateLabel(horz).SetText("Offer Peace");
	offerpeacebutton = UI.CreateButton(horz).SetText("Offer Peace").SetOnClick(OpenOfferPeace);
	local horz = UI.CreateHorizontalLayoutGroup(vert);
	--UI.CreateLabel(horz).SetText("Offer Allianze");
	offerallianzebutton = UI.CreateButton(horz).SetText("Offer Alliance").SetOnClick(OpenOfferAlliance);
  	local horz = UI.CreateHorizontalLayoutGroup(vert);
  	--UI.CreateLabel(horz).SetText("Pending Requests");
	pendingrequestbutton = UI.CreateButton(horz).SetText("Pending Requests").SetOnClick(OpenPendingRequests);
end
function Openshop(rootParent)
	--DeleteUI();
end
function OpenDeclarWar(rootParent)
	DeleteUI();
	local horz = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(horz).SetText("Declare war on: ");
	TargetPlayerBtn = UI.CreateButton(horz).SetText("Select player...").SetOnClick(TargetPlayerClicked);
end
function stringtotable(variable)
	chartable = {};
	while(string.len(variable)>0)do
		chartable[tablelength(chartable)] = string.sub(variable, 1 , 1);
		variable = string.sub(variable, 2);
	end
	local newtable = {};
	local tablepos = 0;
	local executed = false;
	for _, elem in pairs(chartable)do
		if(elem == ",")then
			tablepos = tablepos + 1;
			newtable[tablepos] = "";
			executed = true;
		else
			if(executed == false)then
				tablepos = tablepos + 1;
				newtable[tablepos] = "";
				executed = true;
			end
			if(newtable[tablepos] == nil)then
				newtable[tablepos] = elem;
			else
				newtable[tablepos] = newtable[tablepos] .. elem;
			end
		end
	end
	return newtable;
end
function TargetPlayerClicked()
	print('Test');
	local options = {};
	if(Mod.PublicGameData.War ~= nil and Mod.PublicGameData.War[Game.Us] ~= nil)then
		local inwarwith = stringtotable(Mod.PublicGameData.War[Game.Us]);
		for _,playerinstanze in pairs(Game.Game.Players)do
			local Match = false;
			for _,with in pairs(inwarwith)do
				if(with == playerinstanze.ID)then
					Match = true;
				end
			end
			if(Match == false)then
				table.insert(options,playerinstanze);
			end
		end
	else	
		for _,playerinstanze in pairs(Game.Game.Players)do
			table.insert(options,playerinstanze);
		end
	end
	options = map(options, PlayerButton);
	UI.PromptFromList("Select the player you'd like to declare war on", options);
end
function map(array, func)
	local new_array = {};
	local i = 1;
	for _,v in pairs(array) do
		new_array[i] = func(v);
		i = i + 1;
	end
	return new_array;
end
function PlayerButton(player)
	local name = player.DisplayName(nil, false);
	print(name);
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		TargetPlayerBtn.SetText(name);
		TargetPlayerID = player.ID;
	end
	return ret;
end
function DeleteUI()
	if(TargetPlayerBtn ~= nil)then
		UI.Destroy(TargetPlayerBtn);
		TargetPlayerBtn = nil;
	end
	if(openshopbutton ~= nil)then
		UI.Destroy(openshopbutton);
		openshopbutton = nil;
	end
	if(declarewarbutton ~= nil)then
		UI.Destroy(declarewarbutton);
		declarewarbutton = nil;
	end
	if(offerpeacebutton ~= nil)then
		UI.Destroy(offerpeacebutton);
		offerpeacebutton = nil;
	end
	if(offerallianzebutton ~= nil)then
		UI.Destroy(offerallianzebutton);
		offerallianzebutton = nil;
	end
	if(pendingrequestbutton ~= nil)then
		UI.Destroy(pendingrequestbutton);
		pendingrequestbutton = nil;
	end
end
function  tablelength(T)
	local count = 0;
	for _, elem in pairs(T)do
		count = count + 1;
	end
	return count;
end
