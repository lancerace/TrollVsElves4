"use strict";

function OnPlayerLumberChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer();
	var lumber = args.lumber;
	$('#LumberText').text = Math.floor(lumber);
}

function OnPlayerGoldChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer();
	var gold = args.gold;
	$('#GoldText').text = Math.floor(gold);
}

function OnPlayerFoodChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer();
	var food = args.food;
	var maxFood = args.maxFood;
	$('#CheeseText').text = food + "/" + maxFood;
}

function OnPlayerLumberPriceChanged ( args ){
	var lumberPrice = args.lumberPrice;
	$("#LumberPriceText").text = lumberPrice;
	
}

function HideCheesePanel(){
	$("#CheeseLumberPricePanel").style.opacity = "0";
}


var lumberPopupSchedules = {};
var lumberPopupColor = [10, 200, 90];
function TreeWispHarvestStarted(args) {
	PopupNumbersInterval(lumberPopupSchedules, args.entityIndex, args.amount, args.interval, lumberPopupColor, 
		0, null);
}
function TreeWispHarvestStopped(args) {
	StopNumberPopupInterval(lumberPopupSchedules, args.entityIndex);
}

var goldPopupSchedules = {};
var goldPopupColor = [255, 200, 33];
function GoldGainStarted(args) {
	PopupNumbersInterval(goldPopupSchedules, args.entityIndex, args.amount, args.interval, goldPopupColor, 
		0, null);
}
function GoldGainStopped(args) {
	StopNumberPopupInterval(goldPopupSchedules, args.entityIndex);
}

function PopupNumbersInterval(schedulesArray, entityIndex, amount, interval, color, presymbol, postsymbol) {
	schedulesArray[entityIndex] = $.Schedule(interval, function PopupNumberInterval() {
		PopupNumbers(entityIndex, "damage", color, 3, amount, presymbol, postsymbol);
		schedulesArray[entityIndex] = $.Schedule(interval, PopupNumberInterval);
	});
}

function StopNumberPopupInterval(schedulesArray, entityIndex) {
	$.CancelScheduled(schedulesArray[entityIndex]);
}


// -- Customizable version.
function PopupNumbers(entityIndex, pfx, color, lifetime, number, presymbol, postsymbol) {
    var pfxPath = "particles/msg_fx/msg_" + pfx + ".vpcf";
    var pidx = Particles.CreateParticle(pfxPath, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, entityIndex);

    var digits = 0;
    if (number != null) {
        digits = number.toString().length;
	}
    if (presymbol != null) {
		digits++;
	}
    if(postsymbol != null) {
		digits++;
	}
    Particles.SetParticleControl(pidx, 1, [presymbol, number, postsymbol]);
    Particles.SetParticleControl(pidx, 2, [lifetime, digits, 0]);
	Particles.SetParticleControl(pidx, 3, color);
	Particles.ReleaseParticleIndex(pidx);
}

(function () {
	GameEvents.Subscribe("player_lumber_changed", OnPlayerLumberChanged);
	GameEvents.Subscribe("player_custom_gold_changed",OnPlayerGoldChanged);
	GameEvents.Subscribe("player_food_changed",OnPlayerFoodChanged);
	GameEvents.Subscribe("player_lumber_price_changed",OnPlayerLumberPriceChanged);
	GameEvents.Subscribe("hide_cheese_panel",HideCheesePanel);
	GameEvents.Subscribe("tree_wisp_harvest_start", TreeWispHarvestStarted);
	GameEvents.Subscribe("tree_wisp_harvest_stop", TreeWispHarvestStopped);
	GameEvents.Subscribe("gold_gain_start", GoldGainStarted);
	GameEvents.Subscribe("gold_gain_stop", GoldGainStopped);
})();