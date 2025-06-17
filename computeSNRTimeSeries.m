function [timeVec, marginVec, azVec, elVec, rangeVec] = computeSNRTimeSeries( ...
    sat, sc, lat, lon, freqGHz, txPower, txGain, rxGain, reqSNR)

    % Constants
    losses = 2;  % dB
    timeVec = sc.StartTime:seconds(sc.SampleTime):sc.StopTime;
    N = numel(timeVec);

    % Output arrays
    marginVec = zeros(1, N);
    azVec     = zeros(1, N);
    elVec     = zeros(1, N);
    rangeVec  = zeros(1, N);

    % Ground station
    gs = groundStation(sc, "Latitude", lat, "Longitude", lon);

    % Loop over time
    for k = 1:N
        [az, el, range] = aer(gs, sat(1), timeVec(k));  % range in meters
        rangeKm = range / 1000;

        % Store azimuth, elevation, distance
        azVec(k)    = az;
        elVec(k)    = el;
        rangeVec(k) = rangeKm;

        % FSPL and received power
        fspl = 20*log10(rangeKm) + 20*log10(freqGHz) + 92.45;
        prx = txPower + txGain + rxGain - fspl - losses;

        % Margin
        marginVec(k) = prx - reqSNR;
    end
end
