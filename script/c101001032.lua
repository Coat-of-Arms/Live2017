--トレジャー・パンダー
--Treasure Pander
--Script by nekrozar
function c101001032.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101001032.sptg)
	e1:SetOperation(c101001032.spop)
	c:RegisterEffect(e1)
end
function c101001032.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c101001032.filter(c,e,tp,lv)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101001032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=math.min(3,Duel.GetMatchingGroupCount(c101001032.cfilter,tp,LOCATION_GRAVE,0,nil))
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c101001032.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ct)
	end
	local cg=Duel.GetMatchingGroup(c101001032.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=math.min(3,cg:GetCount())
	local tg=Duel.GetMatchingGroup(c101001032.filter,tp,LOCATION_DECK,0,nil,e,tp,ct)
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101001032,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,lv,lv,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101001032.sfilter(c,lv,e,tp)
	return c:IsType(TYPE_NORMAL) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101001032.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101001032.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end