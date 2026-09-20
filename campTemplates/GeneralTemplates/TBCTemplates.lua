

--********************************************************
--*TEMPLATES PORTED DIRECTLY FROM BLIZZ RETAIL TO CLASSIC*
--********************************************************

CamperClassic_NumericInputBoxMixin = {};
function CamperClassic_NumericInputBoxMixin:OnTextChanged(isUserInput)
	self.valueChangedCallback(self:GetNumber(), isUserInput);
end
function CamperClassic_NumericInputBoxMixin:OnEditFocusLost()
	EditBox_ClearHighlight(self);
	self.valueFinalizedCallback(self:GetNumber());
end
function CamperClassic_NumericInputBoxMixin:SetOnValueChangedCallback(valueChangedCallback)
	self.valueChangedCallback = valueChangedCallback;
end
function CamperClassic_NumericInputBoxMixin:SetOnValueFinalizedCallback(valueFinalizedCallback)
	self.valueFinalizedCallback = valueFinalizedCallback;
end

CamperClassic_SliderControlFrameMixin = {};
function CamperClassic_SliderControlFrameMixin:OnEnter()
end
function CamperClassic_SliderControlFrameMixin:OnLeave()
end
function CamperClassic_SliderControlFrameMixin:SetupSlider(minValue, maxValue, value, valueStep, label)
	self.minValue = minValue;
	self.maxValue = maxValue;
	self.Slider:SetMinMaxValues(minValue, maxValue);
	self.valueStep = valueStep;
	self.Slider:SetValueStep(valueStep);
	self.value = value;
	self.Slider:SetValue(value);
	self.Label:SetText(label);
end
function CamperClassic_SliderControlFrameMixin:OnSliderValueChanged(value, userInput)
	-- Override in your mixin.
end
CamperClassic_SliderWithButtonsAndLabelMixin = CreateFromMixins(CamperClassic_SliderControlFrameMixin);
function CamperClassic_SliderWithButtonsAndLabelMixin:OnSliderValueChanged(value, userInput)
	-- Overrides CamperClassic_SliderControlFrameMixin.
	self.value = value;
	self.IncrementButton:SetEnabled(value < self.maxValue);
	self.DecrementButton:SetEnabled(value > self.minValue);
end
function CamperClassic_SliderWithButtonsAndLabelMixin:Increment()
	local userInput = true;
	self.Slider:SetValue(self.value + self.valueStep, userInput);
end
function CamperClassic_SliderWithButtonsAndLabelMixin:Decrement()
	local userInput = true;
	self.Slider:SetValue(self.value - self.valueStep, userInput);
end
CamperClassic_SliderAndEditControlMixin = CreateFromMixins(CamperClassic_SliderControlFrameMixin);
function CamperClassic_SliderAndEditControlMixin:SetupSlider(minValue, maxValue, value, valueStep, label)
	CamperClassic_SliderControlFrameMixin.SetupSlider(self, minValue, maxValue, value, valueStep, label);
	self.ValueBox:SetNumber(value);
	local function ValueBoxFinalizedCallback(valueBoxValue)
		local isUserInput = true;
		self:SetValue(valueBoxValue, isUserInput);
	end
	self.ValueBox:SetOnValueFinalizedCallback(ValueBoxFinalizedCallback);
end
function CamperClassic_SliderAndEditControlMixin:OnSliderValueChanged(value, isUserInput)
	-- Overrides CamperClassic_SliderControlFrameMixin.
	self.ValueBox:SetNumber(value);
	if self.callback ~= nil then
		self.callback(value, isUserInput);
	end
end
function CamperClassic_SliderAndEditControlMixin:SetValue(value, isUserInput)
	self.Slider:SetValue(Clamp(value, self.minValue, self.maxValue), isUserInput);
end
function CamperClassic_SliderAndEditControlMixin:SetCallback(callback)
	self.callback = callback;
end

---------------------------------------------------------------------------------------------------------------------------------------------
