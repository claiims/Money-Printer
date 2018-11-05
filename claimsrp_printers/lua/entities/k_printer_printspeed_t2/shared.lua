ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Tier 2 Speed Increase";
ENT.Author = "Iamgoofball & Koolaidmini";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "owning_ent");
end;

ENT.Category = "ClaimsRP - Printers"
ENT.ShouldUpgrade = true