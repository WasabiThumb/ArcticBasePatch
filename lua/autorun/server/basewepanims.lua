// Animation Precept
// This will go in lua/autorun/server/basewepanims.lua
// You only need ONE of these files, and ONLY if you are using the modified Arctic base

hook.Add("CalcMainActivity", "changeAnimsPerBaseWEP", function(ply, vel)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) then
		if wep.Anim_Run_Bool then
			return wep.Anim_Run
		end
	end
end )
