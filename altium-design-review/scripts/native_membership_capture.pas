var
    WS, Prj, Flat, Comp, Pin, P, D, SD : IDispatch;
    Phase, Pi, Di, Ci, Ni, PinTotal : Integer;
    Target, Root, State, NetName : String;
    Rows, States : TStringList;
    CompileOk, CompileCancelled, CanRun : Boolean;
// Render these two placeholders with Pascal-escaped absolute paths.
// MCP sandbox body only; requires run_altium_script and SandboxLog.
Root := '__OUTPUT_DIRECTORY__\';
Target := '__PROJECT_PATH__';
WS := GetWorkspace;
CanRun := FileExists(Target) and DirectoryExists(Root);
if FileExists(Root + 'native-connectivity.tsv') or FileExists(Root + 'workspace-states.tsv') then CanRun := False;
for Pi := 0 to WS.DM_ProjectCount - 1 do
begin
    P := WS.DM_Projects(Pi);
    if UpperCase(P.DM_ProjectFullPath) = UpperCase(Target) then CanRun := False;
end;
if not CanRun then ResultText := 'ERROR: Require a closed disposable project, existing output directory and unused output files' else
begin
Rows := TStringList.Create;
States := TStringList.Create;
Rows.Add('refdes' + #9 + 'pin' + #9 + 'net' + #9 + 'local_net');
PinTotal := 0;
try
    for Phase := 0 to 1 do
    begin
        States.Add('phase' + #9 + IntToStr(Phase));
        P := WS.DM_FocusedProject;
        if P <> Nil then States.Add('focused_project' + #9 + P.DM_ProjectFullPath);
        for Pi := 0 to WS.DM_ProjectCount - 1 do
        begin
            P := WS.DM_Projects(Pi);
            if P.DM_ProjectFullPath <> Target then
            begin
                States.Add('project' + #9 + P.DM_ProjectFullPath);
                for Di := 0 to P.DM_LogicalDocumentCount - 1 do
                begin
                    D := P.DM_LogicalDocuments(Di);
                    SD := Client.GetDocumentByPath(D.DM_FullPath);
                    State := 'closed';
                    if SD <> Nil then
                    begin
                        State := 'open';
                        if SD.Modified then State := 'modified';
                    end;
                    States.Add('document' + #9 + D.DM_FullPath + #9 + State);
                end;
            end;
        end;
        States.SaveToFile(Root + 'workspace-states.tsv');
        if Phase = 0 then
        begin
            SandboxLog('Opening exact disposable project');
            Prj := WS.DM_OpenProject(Target, True);
            if Prj = Nil then ResultText := 'ERROR: Disposable project did not open' else
            begin
            try
                if Prj.DM_ProjectFullPath <> Target then ResultText := 'ERROR: Wrong project path' else
                begin
                SandboxLog('Opening an exact project sheet before forced compile');
                for Di := 0 to Prj.DM_LogicalDocumentCount - 1 do
                begin
                    D := Prj.DM_LogicalDocuments(Di);
                    if D.DM_DocumentKind = 'SCH' then
                    begin
                        SD := Client.OpenDocument('SCH', D.DM_FullPath);
                        if SD <> Nil then Client.ShowDocument(SD);
                        Break;
                    end;
                end;
                SandboxLog('Forcing full compile of disposable project');
                CompileCancelled := False;
                CompileOk := Prj.DM_CompileEx(True, CompileCancelled);
                if (not CompileOk) or CompileCancelled then ResultText := 'ERROR: Compile returned false' else
                begin
                Flat := Prj.DM_DocumentFlattened;
                if Flat = Nil then ResultText := 'ERROR: No flattened native document' else
                begin
                SandboxLog('Reading compiled component pin memberships');
                for Ci := 0 to Flat.DM_ComponentCount - 1 do
                begin
                    Comp := Flat.DM_Components(Ci);
                    for Ni := 0 to Comp.DM_PinCount - 1 do
                    begin
                        Pin := Comp.DM_Pins(Ni);
                        NetName := Pin.DM_FlattenedNetName;
                        Rows.Add(Comp.DM_PhysicalDesignator + #9 + Pin.DM_PinNumber + #9 + NetName + #9 + Pin.DM_NetName);
                        Inc(PinTotal);
                    end;
                end;
                Rows.SaveToFile(Root + 'native-connectivity.tsv');
                ResultText := 'native_components=' + IntToStr(Flat.DM_ComponentCount) + ';native_pins=' + IntToStr(PinTotal);
                if PinTotal = 0 then ResultText := 'ERROR: Empty native membership; ' + ResultText;
                end;
                end;
                end;
            finally
                SandboxLog('Closing disposable project without saving');
                WS.DM_CloseProject(Target);
            end;
            end;
        end;
    end;
    SandboxLog('Native export and before/after workspace snapshots complete');
finally
    Rows.Free;
    States.Free;
end;


end;
