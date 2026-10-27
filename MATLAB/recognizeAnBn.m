testWords = {'','ab','aabb','abb','ba','aaabbb','abab','aba','aabbb','aab','acb','abc','cab'};

for i = 1:numel(testWords)
    stack = '';
    phase = 'a';
    isValid = true;
    for j = 1:strlength(testWords{i})
        if testWords{i}(j) == 'a' && phase == 'a'
            stack = [stack 'A'];
        elseif testWords{i}(j) == 'b'
                phase = 'b';
        else
            isValid = false;
            break
        end
        if testWords{i}(j) == 'b' && phase == 'b'
            if isempty(stack)
                isValid = false;
                break
            end
            stack = stack(1:end-1);
        elseif phase == 'b'
            isValid = false;
            break
        end
    end
    if isempty(stack) && isValid
        fprintf('Word %s: Accept\n', testWords{i})
    else
        fprintf('Word %s: Reject\n', testWords{i})
    end
end