AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

function ENT:Initialize()
	self:SetModel( "models/props_junk/garbage_newspaper001a.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	local phys = self:GetPhysicsObject();
	if phys:IsValid() then phys:Wake() end;
	self.IsTier2Paper = true;
end;

/*
function ENT:Use( activator, caller )
end
*/
