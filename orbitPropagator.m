function [sat, sc] = orbitPropagator(StartTime, SimulationTime, SampleTime, tleFilename, gslat, gslon, axesHandle)
% orbitPropagator propagates satellite orbits and evaluates access from a ground station.
%
% INPUTS:
%   StartTime       - datetime object for simulation start time
%   SimulationTime  - duration in hours (scalar)
%   SampleTime      - sample time in seconds (scalar)
%   tleFilename     - string, filename of the TLE file
%   gslat, gslon    - ground station latitude and longitude (in degrees)

    %% Create Satellite Scenario
    stopTime = StartTime + hours(SimulationTime);
    sc = satelliteScenario(StartTime, stopTime, SampleTime);

    %% Load Satellite Constellation from TLE
    if ~isfile(tleFilename)
        error("TLE file not found: %s", tleFilename);
    end

    sat = satellite(sc, tleFilename);
    numSats = numel(sat);
    fprintf("Loaded %d satellites from %s\n", numSats, tleFilename);
    %% Ground track plotting
    groundTrack(sat, "LeadTime", 3600, "TrailTime", 1800);  % 1 hour forward, 30 min back

    %% Add Conical Sensors to Each Satellite
    coneAngle = 20;  % degrees (adjustable)
    sensorNames = sat.Name + " Sensor";
    cam = conicalSensor(sat, "Name", sensorNames, "MaxViewAngle", coneAngle);

    %% Add Ground Station
    gs = groundStation(sc, ...
        "Name", "User Ground Station", ...
        "Latitude", gslat, ...
        "Longitude", gslon, ...
        "MinElevationAngle", 30);

    %% Antenna pattern visualization
    antElem = phased.CosineAntennaElement( ...
    'FrequencyRange', [1e9 2e9], ...      % 1–2 GHz
    'CosinePower', 2);                    % narrower beam than isotropic

    freq = 1.5754e9; %L1 frequency for GPS use
    beam = conicalSensor(sat, ...
    "Name", sat.Name + " Antenna Beam", ...
    "MaxViewAngle", 20);  % Adjust to match -3dB beamwidth from pattern
    

    %% Set Up Access Analysis
    ac = access(cam, gs);

    %% Make satellites track the ground site
    pointAt(sat, gs);

    %% Open Viewer
    v = satelliteScenarioViewer(sc, "ShowDetails", false);
    show(sat(1));  % Focus on first satellite
    sat(1).ShowLabel = true;
    gs.ShowLabel = true;

    %% Visualize FOV for first satellite
    fieldOfView(cam(1));

    %% Compute and Plot System-Wide Access
    for idx = 1:numel(ac)
        [s, timeVec] = accessStatus(ac(idx));
        if idx == 1
            systemWideAccessStatus = s;
        else
            systemWideAccessStatus = or(systemWideAccessStatus, s);
        end
    end

    % Plot access timeline
    plot(axesHandle, timeVec, systemWideAccessStatus, 'LineWidth', 2);
    grid(axesHandle, 'on');
    xlabel(axesHandle, "Time");
    ylabel(axesHandle, "System-Wide Access Status");
    title(axesHandle, "System-Wide Access Timeline");


    % Compute access percentage
    n = nnz(systemWideAccessStatus);
    systemWideAccessDuration = n * sc.SampleTime; % seconds
    scenarioDuration = seconds(sc.StopTime - sc.StartTime);
    systemWideAccessPercentage = (systemWideAccessDuration / scenarioDuration) * 100;

    fprintf("System-Wide Access Time: %.2f minutes (%.2f%% of total)\n", ...
        systemWideAccessDuration / 60, systemWideAccessPercentage);

    %% Play Simulation
    play(sc);
end
