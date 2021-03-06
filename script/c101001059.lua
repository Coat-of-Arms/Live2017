--闇の進軍
--March of Darkness
--Scripted by Eerie Code, fixed by senpaizuri
function c101001059.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101001059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101001059.target)
	e1:SetOperation(c101001059.activate)
	c:RegisterEffect(e1)
end
function c101001059.filter(c,tp)
	if c:IsType(TYPE_MONSTER) and c:IsSetCard(0x38) and c:GetOriginalLevel()>0 and c:IsAbleToHand() then
		local g=Duel.GetDecktopGroup(tp,c:GetOriginalLevel())
		return g:FilterCount(Card.IsAbleToRemove,nil)==c:GetOriginalLevel()
	else return false end
end
function c101001059.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101001059.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101001059.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101001059.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local ol=g:GetFirst():GetOriginalLevel()
	local rg=Duel.GetDecktopGroup(tp,ol)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,ol,0,0)
end
function c101001059.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local ol=tc:GetOriginalLevel()
		local rg=Duel.GetDecktopGroup(tp,ol)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
