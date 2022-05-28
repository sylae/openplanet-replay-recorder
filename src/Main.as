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
    if (g_replayRecord.m_inProgress && UI::MenuItem("\\$f00" + Icons::Circle + " \\$666("+g_replayRecord.m_totalRecorded+")" + " \\$zReplay Recording in progress")) {
        g_replayRecord.m_inProgress = false;
        g_replayRecord.m_totalRecorded = 0;
    }
    if (UI::IsItemHovered()) {
        UI::BeginTooltip();
        UI::Text("\\$6f9" + Icons::VideoCamera + " \\$zClick to stop recording");
        UI::TextDisabled(Icons::InfoCircle + " Replays are saved to " + g_replayRecord.m_path);
        UI::EndTooltip();
    }
}
