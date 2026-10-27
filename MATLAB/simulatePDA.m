% Simulates PDA

function [isAccepted, trace] = simulatePDA(word)

        stack = '';
        phase = 'a';
        isValid = true;
    
        % Store the initial stack and computation trace
        trace = {['Start: stack = ' stack]};
    
        for j = 1:length(word)
            symbol = word(j);
    
            if symbol == 'a' 
                if phase == 'b'
                    isValid = false;
                    trace{end+1} = 'Reject: a occurs after b';
                    break
                end
    
                stack = [stack 'A'];
                trace{end+1} = ['Read a: push A; stack = ' stack];
                
            elseif symbol == 'b'
                phase = 'b';
    
                if isempty(stack)
                    isValid = false;
                    trace{end+1} = 'Reject: no A available to pop';
                    break
                end
    
                stack = stack(1:end-1);
                trace{end+1} = ['Read b: pop A; stack = ' stack];
    
            else
                isValid = false;
                trace{end+1} = ['Reject: invalid symbol ' symbol];
                break
            end
        end
    
        isAccepted = isValid && isempty(stack);

        if isAccepted
            trace{end+1} = 'Final result: Accept';
        else
            trace{end+1} = 'Final result: Reject';
        end
end
                 