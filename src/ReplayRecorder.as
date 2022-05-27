class ReplayRecord
{
    string m_path;

    bool m_inProgress;
    int m_totalRecorded;

    bool m_finishedOnce;

    bool m_showInterface;

    CGameCtnChallenge@ m_map;
    CSmArenaRulesMode@ m_playgroundScript;
    CSmArenaClient@ m_playground;
    CGameDataFileManagerScript@ m_gameDataFileManager;

    void InitPath()
    {
        string replayPath = IO::FromUserGameFolder("Replays/ReplayRecorder");
        if (!IO::FolderExists(replayPath)) IO::CreateFolder(replayPath);

        m_path = replayPath + "/" + Time::FormatString("%F_%H-%M-%S") + " - " + m_map.MapName;
    }

    void Update()
    {
        @m_playground = cast<CSmArenaClient>(GetApp().CurrentPlayground);
        @m_map = m_playground.Map;
        @m_playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);

        if (m_inProgress) {
            if (m_map !is null && m_playground !is null) {
                if (m_playgroundScript !is null && m_playground.GameTerminals.Length > 0) {
                    CSmPlayer@ player = cast<CSmPlayer>(m_playground.GameTerminals[0].ControlledPlayer);
                    if (m_playground.GameTerminals[0].UISequence_Current == CGameTerminal::ESGamePlaygroundUIConfig__EUISequence::Finish && player !is null && !m_finishedOnce) {
                        m_finishedOnce = true;
                        CSmScriptPlayer@ playerScriptAPI = cast<CSmScriptPlayer>(player.ScriptAPI);
                        CGameGhostScript@ ghost = m_playgroundScript.Ghost_RetrieveFromPlayer(playerScriptAPI);
                        if (ghost !is null) {
                            SaveReplay(ghost);
                            m_playgroundScript.DataFileMgr.Ghost_Release(ghost.Id);
                        }
                    } else if (m_playground.GameTerminals[0].UISequence_Current == CGameTerminal::ESGamePlaygroundUIConfig__EUISequence::Playing && player !is null && m_finishedOnce) {
                        m_finishedOnce = false;
                    }
                }
            } else m_inProgress = false;
        }
    }

    void SaveReplay(CGameGhostScript@ ghost)
    {
        @m_gameDataFileManager = TryGetDataFileMgr();
        if (m_gameDataFileManager !is null) {
            m_totalRecorded++;

            string safeMapName = StripFormatCodes(m_map.MapName);
            string safeUserName = ghost.Nickname;
            string fmtGhostTime = FormatTimer(ghost.Result.Time).Replace(":", "-");
            string replayName = m_totalRecorded + " - " + safeMapName + " - " + safeUserName + " - " + Time::FormatString("%F_%H-%M-%S") + " (" + fmtGhostTime + ")";

            string replayFilePath = m_path + "/" + replayName;
            m_gameDataFileManager.Replay_Save(replayFilePath, m_map, ghost);

            UI::ShowNotification(Icons::Check + " Replay saved " + replayName);
        }
    }

    CGameDataFileManagerScript@ TryGetDataFileMgr()
    {
        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app !is null)
        {
            CSmArenaRulesMode@ playgroundScript = cast<CSmArenaRulesMode>(app.PlaygroundScript);
            if (playgroundScript !is null)
            {
                CGameDataFileManagerScript@ dataFileMgr = cast<CGameDataFileManagerScript>(playgroundScript.DataFileMgr);
                if (dataFileMgr !is null)
                {
                    return dataFileMgr;
                }
            }
        }
        return null;
    }

    void Render()
    {
        if (!m_showInterface) return;
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(10, 10));
        UI::PushStyleVar(UI::StyleVar::WindowRounding, 10.0);
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(10, 6));
        UI::PushStyleVar(UI::StyleVar::WindowTitleAlign, vec2(.5, .5));
        int flags = UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoResize;
        if (UI::Begin("\\$6f9" + Icons::VideoCamera + " \\$zReplay Recorder", m_showInterface, flags)){
            if (m_playground is null) {
                UI::Text("You must be playing a map to be able to record replays.");
            } else {
                if (m_inProgress) {
                    UI::Text("\\$f00" + Icons::Circle + " \\$zRecording...");
                    UI::Text(m_totalRecorded + " replays recorded.");
                    UI::TextDisabled("Replays will be saved in " + m_path);
                    if (UI::Button(Icons::StopCircle + " Stop recording")) {
                        m_inProgress = false;
                        m_totalRecorded = 0;
                    }
                } else {
                    UI::Text(m_map.MapName);
                    UI::TextDisabled(m_map.AuthorNickName);
                    if (UI::Button(Icons::PlayCircle + " Start recording")) {
                        m_inProgress = true;
                        InitPath();
                    }
                }
            }
        }
        UI::End();
        UI::PopStyleVar(4);
    }

    string FormatTimer(int time) {
        int ms = time % 1000;
        time /= 1000;
        int hours = time / 60 / 60;
        int minutes = (time / 60) % 60;
        int seconds = time % 60;

        string result = "";

        if (hours > 0) {
            result += Text::Format("%02d", hours) + ":";
        }
        if (minutes > 0 || (hours > 0 && minutes < 10)) {
            result += Text::Format("%02d", minutes) + ":";
        }
        result += Text::Format("%02d", seconds) + "." + Text::Format("%03d", ms);

        return result;
    }
}