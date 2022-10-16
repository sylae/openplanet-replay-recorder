ReplayRecord@ g_replayRecord;

void Main()
{
    @g_replayRecord = ReplayRecord();
}

void Update(float dt)
{
    g_replayRecord.Update();
}

void RenderInterface()
{
    g_replayRecord.Render();
}

void RenderMenu()
{
    if (
        UI::MenuItem(
            "\\$6f9" + Icons::VideoCamera + " \\$zReplay Recorder",
            g_replayRecord.m_inProgress ? ("\\$f00" + Icons::Circle + " \\$z("+g_replayRecord.m_totalRecorded+")") : "",
            g_replayRecord.m_showInterface
        )
    )
        g_replayRecord.m_showInterface = !g_replayRecord.m_showInterface;
}

void RenderMenuMain(){

	string recColor, labelColor, totalColor;
	if (blinkyOverlayLabel && (Time::get_Stamp() % 2 == 1)) {
		recColor = "\\$800";
		labelColor = "\\$666";
		totalColor = "\\$333";
	} else {
		recColor = "\\$f00";
		labelColor = "\\$z";
		totalColor = "\\$666";
	}


	string overlayStr;
	if (shortOverlayLabel) {
		overlayStr = recColor + Icons::Circle + labelColor + " REC";
	} else {
		overlayStr = recColor + Icons::Circle + totalColor + " ("+g_replayRecord.m_totalRecorded+")" + labelColor + " Replay Recording in progress";
	}
	
	auto pos_orig = UI::GetCursorPos();
	auto textSize = Draw::MeasureString(overlayStr);
	if (rightOverlayLabel) {
		UI::SetCursorPos(vec2(UI::GetWindowSize().x - textSize.x - rightOverlayLabelOffset, pos_orig.y));
	}

	
    if (g_replayRecord.m_inProgress && UI::MenuItem(overlayStr)) {
        g_replayRecord.m_inProgress = false;
        g_replayRecord.m_totalRecorded = 0;
    }
    if (g_replayRecord.m_inProgress && UI::IsItemHovered()) {
        UI::BeginTooltip();
        UI::Text("\\$6f9" + Icons::VideoCamera + " \\$zClick to stop recording");
        UI::TextDisabled(Icons::InfoCircle + " Replays are saved to " + g_replayRecord.m_path);
        UI::EndTooltip();
    }
	if (rightOverlayLabel) {
		UI::SetCursorPos(pos_orig);
	}
}
