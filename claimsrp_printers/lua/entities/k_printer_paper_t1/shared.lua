ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Printer Tier 1 Paper Stack";
ENT.Author = "Iamgoofball & Koolaidmini";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "owning_ent" );
end;

ENT.Category = "ClaimsRP - Printers"
ENT.ShouldUpgrade = true