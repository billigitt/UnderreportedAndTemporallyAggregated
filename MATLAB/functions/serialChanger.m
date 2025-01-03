function wPrime = serialChanger(w,firstWeekDay, t)
%This function changes the serial interval to account for the weekend
%effect. If the day considered is a Saturday or Sunday, we assume the
%serial interval is 0 everywhere, otherwise we make the necessary
%adjustments.

wPrime = w;

if (rem(t+firstWeekDay, 7) == 0) || (rem(t+firstWeekDay, 7) == 1)

    wPrime(:) = 0;

else

    idxISat = 7 - firstWeekDay; %index in incidence of first Saturday
    idxISun = 8 - firstWeekDay;
    idxIMon = 9 - firstWeekDay;

    idxWSat = t - 7 + firstWeekDay; %index in serial of first Saturday
    idxWSun = t - 8 + firstWeekDay;
    idxWMon = t - 9 + firstWeekDay;

    idxWSats = idxWSat:-7:1; idxWSats(idxWSats <= 0) = []; %extend to all Saturdays and discard negative indices
    idxWSuns = idxWSun:-7:1; idxWSuns(idxWSuns <= 0) = [];
    idxWMons = idxWMon:-7:1; idxWMons(idxWMons <= 0) = [];

    wPrime(idxWSats) = 0;
    wPrime(idxWSuns) = 0;
    wIdxSats = w(idxWSats);
    wIdxSuns = w(idxWSuns);
    numMons = length(wPrime(idxWMons));

    if (~isempty(idxWMons))

        for j = 1:numMons

            if (idxWMons(j) >= 3)

            wPrime(idxWMons(j)) = wPrime(idxWMons(j)) + w(idxWMons(j) - 1) +...
                w(idxWMons(j) - 2);

        elseif (idxWMons(j) >= 2)

            wPrime(idxWMons(j)) = wPrime(idxWMons(j)) + ...
                w(idxWMons(j) - 1);

        end

        end

    end

end

end