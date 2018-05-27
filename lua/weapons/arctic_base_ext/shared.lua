
// Arctic's Simple Thirdperson Weapons - 2!
// A remade version of my first-ever addon. Even after 3 years, still nobody else has made another base that caters to third-person usage.
// Designed for use in third person. Comes with its own third-person camera override, which can be disabled.

// Modified by Wasabi~
// Take care, Dopey.

SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AutoSwitchFrom = true
SWEP.AutoSwitchTo = true
SWEP.ThirdPersonWeapon = true // Registers the weapon as third person capable with the camera. Do not change this.
SWEP.DrawCrosshair = false // Disables the default crosshair. Do not change this.

SWEP.PrintName = ""
SWEP.Category = "ASTW2"
SWEP.Slot = 2
SWEP.Author = "Arctic"
SWEP.Contact = "https://steamcommunity.com/id/ArcticWinterZzZ/"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = nil
SWEP.WorldModel = "" // Weapon's world model.

SWEP.Primary.Damage = 33 // Base damage of the weapon.
SWEP.Primary.DamageVariance = 1 // Damage variance of the weapon, the damage done can vary up to this much. (0.0-1.0)
SWEP.Primary.Delay = 60 / 700 // Delay between shots. 60/RPM format is preferred, as the weapon's performance is more obvious.
SWEP.Primary.Acc = 1 / 100 // Spread of the weapon. 1/x format is preferred, as the weapon's performance is more obvious.
SWEP.Primary.Recoil = 500 // Recoil of the weapon. A reasonable figure would be between 100 and 1000.
SWEP.Primary.RecoilAcc = 250 // Recoil accumulation of the weapon.
SWEP.Primary.RecoilRecovery = 2750 // Amount of recoil recovered per second.
SWEP.Primary.Num = 1 // Number of projectiles fired. Mainly for shotguns. 
SWEP.BulletsPerShot = 1 // Number of bullets taken per shot.
SWEP.Primary.Automatic = true // Whether the gun is automatic or not.
SWEP.Primary.Ammo = "smg1" // What ammo type the gun uses.
SWEP.Primary.ClipSize = 30 // Clip size of the gun.
SWEP.Primary.DefaultClip = 0 // Amount of ammo the gun comes with.

SWEP.Projectile = nil // The projectile (Such as a rocket or grenade) the gun fires.
SWEP.ProjectileForce = 2500 // The force with which the gun fires the projectile.
SWEP.ProjectileIsGrenade = false // Whether the projectile is a grenade. Enables special physics improvements.
SWEP.ProjectileAngle = Angle(0, 0, 0) // Angle offset of the projectile.
SWEP.HasDetonator = false // Whether or not the weapon acts as a detonator when "fired" without being in sights. You can also bind "detonator_trigger" for an instant detonator!
SWEP.BurstLength = 0 // If this is more than one, you will only be able to shoot that many bullets at once.
SWEP.Tracer = "tracer" // Tracer the weapon uses.
SWEP.TracerOverride = nil // If set, this overrides the amount of tracers the gun fires (One every X shots).

SWEP.Melee = false

SWEP.Sound = "" // The sound of the gun.
SWEP.Sound_Vol = 100 // How far the sound of the gun will spread. 100 is default.
SWEP.Sound_Pitch = 100 // Pitch of the gun's sound. 100 is default.
SWEP.Sound_Magout = "weapons/ak47/ak47_clipout.wav" // First sound played when reloading. Only active on SMG1, AR2, and Pistol holdtypes.
SWEP.Sound_Magin = "weapons/ak47/ak47_clipin.wav" // Second sound played when reloading.
SWEP.Sound_Boltpull = "weapons/ak47/ak47_boltpull.wav" // Last sound played when reloading, only plays when reloading from an empty magazine.

SWEP.Secondary.Ammo = "" // Ignore this.

SWEP.MagDrop = "" // The magazine model that the gun will drop when it is reloaded, if any. (NOT YET IMPLEMENTED)

SWEP.ReloadTime = 1.75 // Time taken to reload.
SWEP.CannotChamber = false // Whether a gun is abnormal and cannot hold an extra round in its chamber (Open bolt guns or revolvers)

// RELOAD TIMES:
// AR2: 2
// SMG: 2
// Pistol: 1.5
// Revolver: 2.5
// Shotgun: 2.5
// Duel: 3.25
//
// Note: Because of how the reload animation system works, you can usually switch animations and holdtypes freely. Try it!
// i.e. Using Duel as the reload holdtype can look good with the AR2 aim holdtype.

SWEP.sprintinganim = false

SWEP.SpeedMult = 1 // Speed multiplier when aiming, as a fraction of convar speedmult.

SWEP.HoldType_Lowered = "none" // Holdtype used when not aiming the weapon.
SWEP.HoldType_Aim = "ar2" // Holdtype used when aiming the weapon.
SWEP.Anim_Reload = ACT_HL2MP_GESTURE_RELOAD_AR2 // Animation for reloading.
SWEP.Anim_Shoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 // Animation for shooting.
SWEP.Anim_Run = ACT_RUN // Animation for sprinting. Also suggested: ACT_RUN_AIM, ACT_RUN_CROUCH, ACT_RUN_CROUCHAIM...
SWEP.Anim_Run_Bool = true // You technically CAN change this value, but you shouldn't.
SWEP.HoldType_Throw = "grenade" // Holdtype for throwing if needed
SWEP.Magnification = 1.0 // Magnification when aiming down the weapon's sights. Increase for more magnification.
SWEP.TrueScope = false // Whether this weapon uses "True" scopes.
SWEP.TrueScopeImage = Material("scopes/simple.png") // Image of the weapon's true scope.

SWEP.DeployTime = 0.25 // Weapon deploy time. I recommend you don't change this.

function SWEP:Initialize()
    self.EID = self:EntIndex()
    if GetConVar("astw2_infammo"):GetBool() then
        self:SetClip1( self.Primary.ClipSize )
    end
end

function SWEP:Deploy()
    self:SetHoldType( self.HoldType_Lowered )
    self:SetNWBool( "insights", false )
    self.Owner = self:GetOwner()

    if self.ProjectileIsGrenade then
        self:SetNWBool( "grenadeprimed", false )
        if self:Clip1() == 0 then
            self:Holster()
            self:Remove()
        end
    else
        self:SetNWBool( "inreload", false )
        self:SetNWFloat( "Recoil", 0 )
        self:SetNWFloat( "RecoilDir", 0 )
        self:SetNWFloat( "Heat", 0 )
        self:SetNWFloat( "LastFire", 0 )
        if self.BurstLength > 1 then
            self:SetNWInt( "burst", 0 )
        end
    end

    self:SetShouldHoldType()

    if SERVER then
        self.runSpeed = self.Owner:GetRunSpeed()
        self.walkSpeed = self.Owner:GetWalkSpeed()
    end

    if CLIENT then
        self.LastRaiseTime = 0
    end

    self.Owner:DrawViewModel( false, 0 )

    self:SetNextPrimaryFire( CurTime() + self.DeployTime )
end

function SWEP:Holster()
    local timers = {
        "astw2_reload",
        "astw2_animtimer",
        "astw2_animtimer2"
    }

    for i, k in pairs(timers) do
        timer.Remove( k .. self.EID )
    end

    if SERVER then
        if self.walkSpeed and self.runSpeed then
            self.Owner:SetWalkSpeed( self.walkSpeed )
            self.Owner:SetRunSpeed( self.runSpeed )
        end
    end

    return true
end

function SWEP:FireProjectile()
    if SERVER then
        local proj = ents.Create( self.Projectile )
        if ( !IsValid( proj ) ) then print("!!!FAILED TO CREATE PROJECTILE") return end
        proj:SetPos( self.Owner:GetBonePosition( self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") ) + Vector(0, 2, 0) )
        proj:SetAngles( self.Owner:EyeAngles() + self.ProjectileAngle )
        proj:SetOwner( self.Owner )
        proj:SetNWEntity( "Owner", self.Owner )
        proj:Spawn()
        local phys = proj:GetPhysicsObject()
        phys:ApplyForceCenter( (self.Owner:GetAimVector() * self.ProjectileForce) + self.Owner:GetAbsVelocity() )
        if self.ProjectileIsGrenade then
            phys:AddAngleVelocity( VectorRand() * 1000 )
        end
    end
end

function SWEP:Throw()
    if !self:IsValid() then return end
    self:SetNWBool( "grenadeprimed", false )
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self:EmitSound( self.Sound, self.Sound_Vol, self.Sound_Pitch, 1, CHAN_WEAPON )
    self.Owner:DoAnimationEvent( self.Anim_Shoot )
    self:SetShouldHoldType()
    if !GetConVar("astw2_infammo"):GetBool() then
        self:TakePrimaryAmmo(self.BulletsPerShot)
    end
    self:FireProjectile()
    if self:Ammo1() <= 0 then
        self:Holster()
        self:Remove()
    end
end

function SWEP:Detonator()
    self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL )
    self.Owner:ConCommand("detonator_trigger")
end

function SWEP:GetBorePos()
    local shootpos = self.Owner:LookupAttachment( "Anim_Attachment_RH" )

    if shootpos != 0 then
        shootpos = self.Owner:GetAttachment(shootpos).Pos + Vector(0, 0, 4)
    else
        // Alright, revert to backup
        shootpos = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if shootpos != 0 then
            shootpos = self.Owner:GetBonePosition(shootpos) + Vector(0, 0, 4)
        else
            // what the fuck
            shootpos = self.Owner:GetShootPos()
        end
    end

    return shootpos
end

function SWEP:PrimaryAttack()

    if !self:IsValid() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end
    if self.Primary.ClipSize != -1 and self:Clip1() < self.BulletsPerShot then return end
    if self.Primary.ClipSize == -1 and self:Ammo1() < self.BulletsPerShot and !GetConVar("astw2_infammo"):GetBool() then return end
    if self:GetNWBool( "inreload", false ) then return end
    if self.BurstLength > 1 then
        if self:GetNWInt( "burst", 0 ) > (self.BurstLength - 1) then return end
    end

    if !self:GetNWBool( "insights" ) then
        if self.HasDetonator then
            self:Detonator()
        end
        return
    end

    local avoid_recoil = false

    if self.ProjectileIsGrenade then
        self:SetHoldType( self.HoldType_Throw )
        avoid_recoil = true
        self:SetNWBool( "grenadeprimed", true )
        self:SetNextPrimaryFire( CurTime() + 0.25 )
    elseif self.Projectile then
        self:FireProjectile()
    else

        local nt = 3

        if self.TrueScope then
            nt = 0
        elseif self.Primary.Num > 1 then
            nt = 1
        elseif self:Clip1() <= (self.Primary.ClipSize / 8) then
            nt = 1
        end

        if self.TracerOverride != nil then
            nt = self.TracerOverride
        end

        local acc = self.Primary.Acc
        acc = acc + (self:GetNWFloat("Heat", 0) / 15000)

        if self.Primary.Num > 1 then
            acc = acc * GetConVar("astw2_accuracymult_shotgun"):GetFloat()
        else
            acc = acc * GetConVar("astw2_accuracymult"):GetFloat()
            if self:GetNWFloat("Heat", 0) <= 10E-5 and self.Owner:Crouching() then
                acc = acc * 0.5
            end
        end

        local dmg = self.Primary.Damage
        dmg = dmg * GetConVar("astw2_damagemult"):GetFloat()
        dmg = dmg * math.floor(math.Rand(1 - (self.Primary.DamageVariance * GetConVar("astw2_variance"):GetFloat()), 1 + (self.Primary.DamageVariance * GetConVar("astw2_variance"):GetFloat())))

        local shootpos = self:GetBorePos()

        self:FireBullets({
        Attacker = self.Owner,
        Damage = dmg,
        Force = self.Primary.Damage / 3,
        Num = self.Primary.Num,
        Dir = self.Owner:GetAimVector(),
        Src = shootpos,
        Tracer = nt,
        TracerName = self.Tracer,
        Spread 	= Vector( acc, acc, 0 )
        })

    end

    if !avoid_recoil then

        local recoil_amount = self.Primary.Recoil / 100
        recoil_amount = recoil_amount * GetConVar("astw2_recoilmult"):GetFloat()
        local recoil_angle = math.Rand( -1.5, 1.5 )

        self:SetNWFloat( "Heat", self:GetNWFloat("Heat") + (self.Primary.RecoilAcc * GetConVar("astw2_heatmult"):GetFloat()) )

        self:TakePrimaryAmmo(self.BulletsPerShot)
        if SERVER then
            sound.Play( self.Sound, self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")), self.Sound_Vol, self.Sound_Pitch, 1, CHAN_WEAPON )
        end
        self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_PRIMARY, 0 )
        self.Owner:DoAnimationEvent( self.Anim_Shoot )
        self:SetNWFloat( "Recoil", recoil_amount )
        self:SetNWFloat( "RecoilDir", recoil_angle )

        if self.BurstLength > 1 then
            self:SetNWInt( "burst", self:GetNWInt("burst", 0) + 1 )
        end

        if self:Clip1() == 0 then
            self:SetNextPrimaryFire( CurTime() + 0.25 )
        else
            self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
        end

        self:SetNWFloat( "LastFire", CurTime() )

    end

end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:SetShouldHoldType()
    if self:GetNWBool( "insights", false ) then
        self:SetHoldType( self.HoldType_Aim )
    else
        self:SetHoldType( self.HoldType_Lowered )
    end
end

function SWEP:Raise()
    self:SetNWBool( "insights", true )
    self.Owner:SetFOV( 90 / self.Magnification, 0.25 )
    self:SetShouldHoldType()
    self:SetNextPrimaryFire( CurTime() + self.DeployTime )

    if SERVER then
        if GetConVar("astw2_speedmult_enabled"):GetBool() then
            if self.walkSpeed and self.runSpeed then
                self.Owner:SetWalkSpeed( self.walkSpeed * GetConVar("astw2_speedmult"):GetFloat() * self.SpeedMult )
                self.Owner:SetRunSpeed( self.walkSpeed * GetConVar("astw2_speedmult"):GetFloat() * self.SpeedMult )
            else
                self.runSpeed = self.Owner:GetRunSpeed()
                self.walkSpeed = self.Owner:GetWalkSpeed()
                self.Owner:SetWalkSpeed( self.walkSpeed * GetConVar("astw2_speedmult"):GetFloat() * self.SpeedMult  )
                self.Owner:SetRunSpeed( self.walkSpeed * GetConVar("astw2_speedmult"):GetFloat() * self.SpeedMult  )
            end
        end
    else
        self.LastRaiseTime = CurTime()
    end
end

function SWEP:Lower()
    self:SetNWBool( "insights", false )
    self:SetNWBool( "grenadeprimed", false )
    self.Owner:SetFOV( 0, 0.25 )
    self:SetShouldHoldType()

    if SERVER then
        if GetConVar("astw2_speedmult_enabled"):GetBool() then
            if self.walkSpeed and self.runSpeed then
                self.Owner:SetWalkSpeed( self.walkSpeed )
                self.Owner:SetRunSpeed( self.runSpeed )
            end
        end
    end
end

function SWEP:Reload()
    if !self:IsValid() then return end
    if self:GetNWBool( "inreload", false ) then return end
    if self.Primary.ClipSize == -1 then return end
    if self:Clip1() >= self.Primary.ClipSize and self.CannotChamber then return end
    if self:Clip1() >= self.Primary.ClipSize + 1 and !self.CannotChamber then return end
    if self:Ammo1() <= 0 and !GetConVar("astw2_infammo"):GetBool() then return end
    self.Owner:DoAnimationEvent( self.Anim_Reload )
    self:SetNWBool( "inreload", true )
    self:SetNWFloat( "Heat", 0 )

    if self.Anim_Reload == ACT_HL2MP_GESTURE_RELOAD_AR2 or self.Anim_Reload == ACT_HL2MP_GESTURE_RELOAD_SMG1 then
        timer.Simple( 0.1, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Magout) end)
        timer.Simple( 1.0, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Magin) end)
        if self:Clip1() <= 0 then
            timer.Simple( 1.45, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Boltpull) end)
        end
    elseif self.Anim_Reload == ACT_HL2MP_GESTURE_RELOAD_PISTOL then
        timer.Simple( 0.1, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Magout) end)
        timer.Simple( 0.75, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Magin) end)
        if self:Clip1() <= 0 then
            timer.Simple( 1.4, function() if !self:IsValid() then return end self:EmitSound(self.Sound_Boltpull) end)
        end
    end

    self:SetNextPrimaryFire( CurTime() + self.ReloadTime )
    timer.Create( "astw2_reload" .. self.EID, self.ReloadTime + 0.1, 1, function()
        if !self:IsValid() then return end
        if !IsFirstTimePredicted() then return end

        local cs = self.Primary.ClipSize

        if self:Clip1() > 0 and !self.CannotChamber then
            cs = self.Primary.ClipSize + 1
        end

        local setclipto = math.Clamp( cs, 0, self:Ammo1() + self:Clip1() )
        local difference = setclipto - self:Clip1()

        if GetConVar("astw2_infammo"):GetBool() then
            setclipto = cs
            difference = 0
        end

        self:SetClip1( setclipto )
        self.Owner:SetAmmo( math.Clamp( self:Ammo1() - difference, 0, self:Ammo1() ), self.Primary.Ammo )
        self:SetNWBool( "inreload", false )
    end)
end

function SWEP:Think()
    if !self:IsValid() then return end
    if self.Owner:InVehicle() then return end

    if self:GetNWFloat( "Recoil", 0 ) > 0 then
        local recoil_amt = self:GetNWFloat( "Recoil", 0 ) * FrameTime() * 10
        self.Owner:SetEyeAngles( self.Owner:EyeAngles() - Angle( recoil_amt, recoil_amt * self:GetNWFloat( "RecoilDir", 0 ), 0 ) )
        self:SetNWFloat( "Recoil", math.Clamp(self:GetNWFloat( "Recoil", 0 ) - recoil_amt - 0.1, 0, 1000) )
    end

    if self.Owner:KeyPressed( IN_ATTACK ) and self:Clip1() <= 0 and self:GetNextPrimaryFire() <= CurTime() then
        self:Reload()
    end

    if !self.Owner:KeyDown( IN_ATTACK ) then
        self:SetNWFloat( "Heat", math.Clamp(self:GetNWFloat( "Heat" ) - (FrameTime() * self.Primary.RecoilRecovery), 0, 100000))
        if self.BurstLength > 1 then
            self:SetNWInt( "burst", 0 )
        end
    end

    if self:GetNWBool( "grenadeprimed", false ) and self:GetNWBool( "insights", false ) and !self.Owner:KeyDown( IN_ATTACK ) and self.ProjectileIsGrenade and self:GetNextPrimaryFire() < CurTime() then
        self:Throw()
    end

    if self.Owner:KeyDown( IN_ATTACK2 ) or GetConVar("astw2_always_active"):GetBool() then
        if !self:GetNWBool( "insights", true ) then
            self:Raise()
        end
    elseif self:GetNWBool( "insights", true ) then
        self:Lower()
    end

end
