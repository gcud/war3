function Skill_Effect_Charm(u,target,p)
    local Parameter=1
    local Probability=GetUpgradeAbilityLevel(u,Constant.Skill.Charm)*Parameter
    if GetRandomInt(1,100)<=Probability then
        DestroyEffect(AddSpecialEffectTarget("Abilities/Spells/Other/Charm/CharmTarget.mdl", target, "origin"))
        SetUnitOwner(target,GetOwningPlayer(u),true)
        IncreaseAbilityProficiency(p,Constant.Skill.Charm)
    end
end