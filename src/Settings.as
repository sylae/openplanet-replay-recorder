[Setting category="Behavior" name="Automatically begin recording" description="If enabled, recording will automatically begin at the start of every map."]
bool alwaysBeRecording = false;

[Setting category="Display" name="Short label mode" description="A shorter (if less descriptive) recording in progress notification will be shown in the Overlay"]
bool shortOverlayLabel = false;

[Setting category="Display" name="Blinking label" description="Blink the recording indicator, because it's aesthetic af."]
bool blinkyOverlayLabel = false;

[Setting category="Display" name="Right-hand label" description="Show the label on the right-hand side of the Overlay bar. You will need to manually adjust the offset to accomodate other plugins (like Clock)"]
bool rightOverlayLabel = false;

[Setting category="Display" name="Right-hand label offset" description="How far over to put the recording indicator. A value of 200 works well for the Clock plugin."]
int rightOverlayLabelOffset = 0;
