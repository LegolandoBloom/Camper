
CamperPorted_ActionBarButtonSpellActivationAlertMixin = {};
function CamperPorted_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.ProcLoop:IsPlaying() ) then
		self.ProcLoop:Stop();
	end
end

CamperPorted_ActionBarButtonSpellActivationAlertProcStartAnimMixin = { }; 
function CamperPorted_ActionBarButtonSpellActivationAlertProcStartAnimMixin:OnFinished()
	self:GetParent().ProcLoop:Play();
end