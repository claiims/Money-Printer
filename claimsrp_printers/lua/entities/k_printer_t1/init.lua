//// MONEY PRINTER 



AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include( "shared.lua" );

local multiplierupgrade = 300 -- How often should the printer multiplier upgrade. (In seconds)
local MaxMultiplier = 5.0 -- What is the max amount that the multiplier can be. (Float/Decimal value)
local AddMultiplier = 0.1 -- How much should be added to the multiplier. (Float/Decimal value)

-- EDIT DEEZ & NOTHING ELSE --            -- if you want..
local function SetValues( ent )
	ent.printTime = 1; -- Default print time.
	ent.minPrint = 12; -- Minimum print amount.
	ent.maxPrint = 14; -- Maximum print amount.
	ent.upgradedExtra = ent.maxPrint * 0.5; -- The additional income received on upgraded printers.
	ent.printerColor = Color( 189, 99, 39, 255 ); -- The color of the printer prop.
	ent.coolantSystem = true; -- Toggles the coolant system.
	ent.coolantLoss = 0.2; -- The Percentage loss for each print of the coolant is enabled.
end;
------------------------------

local PrintMore;
function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever01a.mdl" );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:SetSolid( SOLID_VPHYSICS );
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject();
	phys:Wake();

	SetValues( self );
	
	self:SetColor( self.printerColor );
	self.CoolantOut = false
	self.damage = 100;
	self.IsMoneyPrinter = true;
	self:SetNWInt( "Amount", 0 );
	self:SetNWFloat("Multiplier",1.0);
	self:SetNWInt( "Health", 100 );
	self:SetNWBool( "Upgraded", false );
	self:SetNWBool( "Armor", false );
	self:SetNWBool( "SpeedUpgrade", false );
	self:SetNWBool( "Paper", false );
	if self.coolantSystem then
		self:SetNWInt( "Coolant", 100 );
		self:SetNWBool( "CoolantToggle", true );
	end;
	timer.Simple( 0.1, function() PrintMore( self ) end );
end;

function ENT:OnTakeDamage( dmg )
	self.damage = ( self.damage ) - math.ceil( dmg:GetDamage() );
	if self.damage < 0 then self.damage = 0 end;
	self:SetNWInt( "Health", self.damage );
end;

function ENT:StartTouch( hitEnt )
	if self:GetNWBool( "CoolantToggle" ) then
		if hitEnt.IsCoolant then

			if self.CoolantOut == true && self:GetNWInt("Coolant") == 0 then
				self.CoolantOut = false
				timer.Simple( 0.1, function() PrintMore( self ) end );
			end

			self.Coolant = hitEnt;
			local amount = self:GetNWInt( "Coolant" ) + 100;
			if amount > 100 then amount = 100 end;
			self:SetNWInt( "Coolant", amount );
			self.Coolant:Remove();
		end;
	end;
	if ( hitEnt.IsUpgrade ) then 
		if ( !self:GetNWBool( "Upgraded" ) ) then
			self:SetNWBool( "Upgraded", true );
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier1Armor ) then 
		if ( !self:GetNWBool( "Armor" ) ) then
			self:SetNWBool( "Armor", true );
			self.damage = self.damage + 500;
			self:SetNWInt( "Health", self.damage );
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier2Armor ) then 
		if ( !self:GetNWBool( "Armor" ) ) then
			self:SetNWBool( "Armor", true );
			self.damage = self.damage + 300;
			self:SetNWInt( "Health", self.damage );
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier3Armor ) then 
		if ( !self:GetNWBool( "Armor" ) ) then
			self:SetNWBool( "Armor", true );
			self.damage = self.damage + 500;
			self:SetNWInt( "Health", self.damage );
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier1PrintSpeed ) then 
		if ( !self:GetNWBool( "SpeedUpgrade" ) ) then
			self:SetNWBool( "SpeedUpgrade", true );
			self.printTime = self.printTime - 3;
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier2PrintSpeed ) then 
		if ( !self:GetNWBool( "SpeedUpgrade" ) ) then
			self:SetNWBool( "SpeedUpgrade", true );
			self.printTime = self.printTime - 5;
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier3PrintSpeed ) then 
		if ( !self:GetNWBool( "SpeedUpgrade" ) ) then
			self:SetNWBool( "SpeedUpgrade", true );
			self.printTime = self.printTime - 9;
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier1Paper ) then 
		if ( !self:GetNWBool( "Paper" ) ) then
			self:SetNWBool( "Paper", true );
			self.maxPrint = self.maxPrint + 10;
			self.minPrint = self.minPrint + 10;
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier2Paper ) then 
		if ( !self:GetNWBool( "Paper" ) ) then
			self:SetNWBool( "Paper", true );
			self.maxPrint = self.maxPrint + 20;
			self.minPrint = self.minPrint + 20;
			hitEnt:Remove();
		end;
	end
	if ( hitEnt.IsTier3Paper ) then 
		if ( !self:GetNWBool( "Paper" ) ) then
			self:SetNWBool( "Paper", true );
			self.maxPrint = self.maxPrint + 30;
			self.minPrint = self.minPrint + 30;
			hitEnt:Remove();
		end;
	end
end

function ENT:Use( activator )

	self:SetAngles(Angle(0, self:GetAngles().y, 0))

	local phys = self:GetPhysicsObject();
	phys:Wake();

	if ( activator:IsPlayer() and self:GetNWInt( "Amount" ) > 0 ) then
		activator:addMoney( self:GetNWInt( "Amount" ) );
		DarkRP.notify( activator, 0, 4, "You have collected $" .. self:GetNWInt( "Amount" ) .. " from a " .. self.PrintName );
		self:SetNWInt( "Amount", 0 );
	end;

	if self:GetNWInt("Coolant",0) <= 0 then

		DarkRP.notify( self:Getowning_ent(), 0, 4, "This printer requires coolant refilling to continue printing." );
		return

	end;

end;

function ENT:Destruct()
	local vPoint = self:GetPos();
	local effectdata = EffectData();
	effectdata:SetStart( vPoint );
	effectdata:SetOrigin( vPoint );
	effectdata:SetScale( 1 );
	util.Effect( "Explosion", effectdata );
	DarkRP.notify( self:Getowning_ent(), 1, 4, "Your " .. self.PrintName .. " has exploded!" );
end;

function ENT:BurstIntoFlames()
	DarkRP.notify( self:Getowning_ent(), 0, 4, "Your " .. self.PrintName .. " has burst into flames!" );
	self.burningup = true;
	local burntime = math.random( 8, 18 );
	self:Ignite( burntime, 0 );
	timer.Simple( burntime, function() self:Fireball() end );
end;

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end;
	local dist = math.random( 20, 280 ); -- Explosion radius
	self:Destruct();
	for k, v in pairs( ents.FindInSphere( self:GetPos(), dist ) ) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite( math.random( 5, 22 ), 0 );
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance( self:GetPos() );
			v:TakeDamage( distance / dist * 100, self, self );
		end;
	end;
	self:Remove();
end;

PrintMore = function( ent )
	if not IsValid( ent ) then return end;
	if ent.damage <= 0 then return end;
	
	timer.Simple( ent.printTime / 2, function()
		if not IsValid( ent ) then return end;
		ent:CreateMoney();
	end );
end;

--Timer to upgrade all printer multipliers.		
timer.Create("PS_PRINTERS_MULTIPLIERS",multiplierupgrade,0,function(  )		
	for k,v in pairs(ents.GetAll()) do		
		if v:IsValid() && v.ShouldUpgrade && v:GetNWFloat("Multiplier") < MaxMultiplier then		
			v:SetNWFloat("Multiplier",v:GetNWFloat("Multiplier") + AddMultiplier)		
		end		
	end		
end)

function ENT:CreateMoney()
	if not IsValid( self ) then return end;
	if self:IsOnFire() then return end;

	if self:GetNWInt("Coolant",0) <= 0 then

		DarkRP.notify( self:Getowning_ent(), 0, 4, "Your " .. self.PrintName .. " requires coolant refilling to continue printing." );
		self.CoolantOut = true
		return

	end;

	if self:GetNWBool( "CoolantToggle" ) then
		local coolantLeft = self:GetNWInt( "Coolant" ) - self.coolantLoss;
		self:SetNWInt( "Coolant", coolantLeft );
		if coolantLeft <= 0 then
			self:SetNWInt( "Coolant", 0 );
		end;
	end;

	local PrintAmount = math.random( self.minPrint, self.maxPrint );
	if self:GetNWBool( "Upgraded" ) then
		PrintAmount = PrintAmount + math.ceil( self.upgradedExtra );
	end;
	
	local TotalAmount = self:GetNWInt( "Amount" ) + (PrintAmount * self:GetNWFloat("Multiplier"));
	self:SetNWInt( "Amount", math.Round(TotalAmount,0) );
	
	if self.damage < 500 then 
		self.damage = self.damage + 1;
		self:SetNWInt( "Health", self.damage );
	end;
	
	timer.Simple( self.printTime / 2, function() PrintMore( self ) end );
end;

function ENT:Think()
	if self.damage then
		if ( self.damage <= 0 ) then
			if not self:IsOnFire() then
				self.damage = 0;
				self:SetNWInt( "Health", 0 );
				
				self:BurstIntoFlames();	
			end;
		end;
	end;

	if self:WaterLevel() > 0 then
		self:Destruct();
		self:Remove();
		return;
	end;

end;

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop();
	end;
end
