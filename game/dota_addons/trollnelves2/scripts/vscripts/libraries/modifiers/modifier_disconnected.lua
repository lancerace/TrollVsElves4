modifier_disconnected = class({})


function modifier_disconnected:CheckState() 
    return { [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
end

function modifier_disconnected:IsHidden()
    return true
end

function modifier_disconnected:IsPurgable()
    return false
end