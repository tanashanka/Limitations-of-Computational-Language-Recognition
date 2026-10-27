% Simulates 3-state DFA

function [isAccepted, trace] = simulateFA(word)
    % States:
    % q0 = reading a's (or no symbol yet)
    % q1 = reading b's
    % qInv = invalid order or symbol

    state = 'q0';
    trace = {['Start: state = ' state]};

    for j = 1:length(word)
        symbol = word(j);

        switch state
            case 'q0'
                if symbol == 'a'
                    state = 'q0';
                elseif symbol == 'b'
                    state = 'q1';
                else
                    state = 'qInv';
                end
            case 'q1'
                if symbol == 'b'
                    state = 'q1';
                else 
                    state = 'qInv';
                end
            case 'qInv'
                state = 'qInv';
        end

        trace{end+1} = ['Read ' symbol ': state = ' state];
    end

    % q0 and q1 are accepting states, qInv is rejecting
    isAccepted = ~strcmp(state, 'qInv');
end