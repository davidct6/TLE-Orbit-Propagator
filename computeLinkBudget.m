function result = computeLinkBudget(sat, sc, lat, lon, ...
    freqGHz, txPower, txGain, rxGain, reqSNR)
    
    losses = 2; 
    % Use scenario time (start or current)
    time = sc.StartTime;

    % Create temporary ground station
    gs = groundStation(sc, "Latitude", lat, "Longitude", lon);

    % Get range to first satellite
    [~, ~, range] = aer(gs, sat(1), time);  % meters
    rangeKm = range / 1000;

    % FSPL calculation
    fspl = 20*log10(rangeKm) + 20*log10(freqGHz) + 92.45;

    % Received power
    prx = txPower + txGain + rxGain - fspl - losses;

    % Link margin
    margin = prx - reqSNR;

    % Bundle results
    result = struct();
    result.RangeKm = rangeKm;
    result.FSPL = fspl;
    result.ReceivedPower = prx;
    result.Margin = margin;
end
